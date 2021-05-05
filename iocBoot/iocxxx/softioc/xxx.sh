#!/bin/bash
#
# description: start/stop/restart an EPICS IOC in a screen session
#

# Manually set IOC_STARTUP_DIR if xxx.sh will reside somewhere other than softioc
#!IOC_STARTUP_DIR=/home/username/epics/ioc/synApps/xxx/iocBoot/iocxxx/softioc

# Manually set IOC_COMMAND_DIR if xxx.sh will reside somewhere other than softioc
#!IOC_COMMAND_DIR=/home/username/epics/ioc/synApps/xxx/iocBoot/iocxxx/softioc/commands


# Set EPICS_HOST_ARCH if the env var isn't already set properly for this IOC
#!EPICS_HOST_ARCH=linux-x86_64
#!EPICS_HOST_ARCH=linux-x86_64-debug

IOC_NAME=xxx
# The name of the IOC binary isn't necessarily the same as the name of the IOC
IOC_BINARY=xxx

# The RUN_IN variable defines how the IOC should be run. Valid options:
#   screen		(run in a screen session)
#   procServ	(run in procServ)
#   shell		(run on the shell--turns 'start' argument into 'run')
RUN_IN=screen

# The PROCSERV_ENDPOINT variable defines the type of control endpoint to be used
#   tcp			(tcp port)
#   unix		(unix socket)
PROCSERV_ENDPOINT=tcp

# Extra procServ options:
#   -w             start procServ, but require the IOC to be started manually
#   -o             run the IOC once, then quit procServ when the IOC exits
#   --allow        allow telnet access from anywhere
#   --restrict     only allow access from localhost explicitly (the default behavior)
#   -l <endpoint>  create a read-only log endpoint (endpoint = port # or socket filename)
#!PROCSERV_OPTIONS="-w"
#!PROCSERV_OPTIONS="-o"
#!PROCSERV_OPTIONS="--allow"

# The procServ info file is required by this script, but its name can be customized here
PROCSERV_INFO_FILE=ioc${IOC_NAME}-ps-info.txt

# Initial values for procServ endpoints 
PROCSERV_PORT=-1
PROCSERV_SOCKET=ioc${IOC_NAME}.socket

# Change YES to NO in the following line to disable screen-PID lookup, which isn't supported on Windows
GET_SCREEN_PID=YES

# Commands needed by this script
ECHO=echo
ID=id
PGREP=pgrep
SCREEN=screen
KILL=kill
BASENAME=basename
DIRNAME=dirname
READLINK=readlink
PS=ps
#
PROCSERV=procServ
TELNET=telnet
SOCAT=socat
HEAD=head
TAIL=tail
CUT=cut
NC=nc
# Explicitly define paths to commands if commands aren't found
#!ECHO=/bin/echo
#!ID=/usr/bin/id
#!PGREP=/usr/bin/pgrep
#!SCREEN=/usr/bin/screen
#!KILL=/bin/kill
#!BASENAME=/bin/basename
#!DIRNAME=/usr/bin/dirname
#!READLINK=/bin/readlink
#!PS=/bin/ps

#####################################################################

SNAME=${BASH_SOURCE:-$0}
SELECTION=$1

SEL_ARGS=()

if [ $# -gt 1 ] ; then
	SEL_ARGS=${@:2:$(($#-1))}
fi


# uncomment for your OS here (comment out all the others)
#IOC_STARTUP_FILE="st.cmd.Cygwin"
IOC_STARTUP_FILE="st.cmd.Linux"
#IOC_STARTUP_FILE="st.cmd.vxWorks"
#IOC_STARTUP_FILE="st.cmd.Win32"
#IOC_STARTUP_FILE="st.cmd.Win64"

if [ -z "$IOC_STARTUP_DIR" ] ; then
    # If no startup dir is specified, use the directory above the script's directory
    IOC_STARTUP_DIR=`dirname ${SNAME}`/..
    IOC_CMD="../../bin/${EPICS_HOST_ARCH}/${IOC_BINARY} ${IOC_STARTUP_FILE}"
else
    IOC_CMD="${IOC_STARTUP_DIR}/../../bin/${EPICS_HOST_ARCH}/${IOC_BINARY} ${IOC_STARTUP_DIR}/${IOC_STARTUP_FILE}"
fi
#!${ECHO} ${IOC_STARTUP_DIR}

if [ -z "$IOC_COMMAND_DIR" ] ; then
	IOC_COMMAND_DIR="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )/commands"
fi

# Variables used to calculatate a random port for procServ
START=50000
NUM_PORTS=100

# This variable will be used to perform the correct function for a given argument
RUNNING_IN=TBD

#####################################################################

REGISTERED_CMD_NAMES=()
REGISTERED_CMD_FUNCS=()

register() {
	CMD_NAME=$1
	CMD_FUNC=$2
	
	REGISTERED_CMD_NAMES+=("$CMD_NAME")
	REGISTERED_CMD_FUNCS+=("$CMD_FUNC")
}


parse_procServ_info() {
    # This parses procServ info files
    INFO_FILE=$1
    if [ ! -z ${INFO_FILE} ] ; then
        # function was called with an argument
        if [ -f "${INFO_FILE}" ] ; then
            # info file exists
            #!${ECHO} "INFO_FILE = $INFO_FILE"
            
            # Only read the PID from the info file if the PID hasn't been found yet
            if [ -z ${PROCSERV_PID} ] ; then
                # Get PID
                PROCSERV_PID=$(${HEAD} -n 1 ${INFO_FILE} | cut -d ':' -f 2)
                #!${ECHO} ${PROCSERV_PID}
            fi
            
            # Get control endpoint
            CTL_STR=$(${TAIL} -n 1 ${INFO_FILE})
            if [ $(${ECHO} ${CTL_STR} | ${CUT} -d ':' -f 1) == 'tcp' ]; then
                # tcp control endpoint; port is 3rd item
                PROCSERV_PORT=$(${ECHO} ${CTL_STR} | ${CUT} -d ':' -f 3)
                #!${ECHO} ${PROCSERV_PORT}
            else
                # unix control endpoint; socket is 2nd item
                PROCSERV_SOCKET=$(${ECHO} ${CTL_STR} | ${CUT} -d ':' -f 2)
                #!${ECHO} ${PROCSERV_SOCKET}
            fi
        fi
    fi
}

screenpid() {
    if [ ! -z ${SCREEN_PID} ] ; then
        ${ECHO} " in a screen session (pid=${SCREEN_PID})"
    elif [ ! -z ${PROCSERV_PID} ] ; then
        if [ -z ${SAME_HOST} ] ; then
            ${ECHO} " in procServ on a different computer"
        else
            ${ECHO} " in procServ (pid=${PROCSERV_PID})"
        fi
    else
        ${ECHO}
    fi
}

checkpid() {
    MY_UID=`${ID} -u`
    # The '\$' is needed in the pgrep pattern to select xxx, but not xxx.sh
    IOC_PID=`${PGREP} ${IOC_BINARY}\$ -u ${MY_UID}`
    #!${ECHO} "IOC_PID=${IOC_PID}"

    if [ "${IOC_PID}" != "" ] ; then
        # Assume the IOC is down until proven otherwise
        IOC_DOWN=1

        # At least one instance of the IOC binary is running; 
        # Find the binary that is associated with this script/IOC
        for pid in ${IOC_PID}; do
            BIN_CWD=`${READLINK} /proc/${pid}/cwd`
            IOC_CWD=`${READLINK} -f ${IOC_STARTUP_DIR}`
            
            if [ "$BIN_CWD" = "$IOC_CWD" ] ; then
                # The IOC is running; the binary with PID=$pid is the IOC that was run from $IOC_STARTUP_DIR
                IOC_PID=${pid}
                IOC_DOWN=0
                
                SCREEN_PID=""
                
                # Assume IOC is running in shell until learning otherwise
                RUNNING_IN=shell
                
                if [ "${GET_SCREEN_PID}" = "YES" ] ; then
                    # Get the PID of the parent of the IOC (shell or screen)
                    P_PID=`${PS} -p ${IOC_PID} -o ppid=`
                    
                    # Get the PID of the grandparent of the IOC (sshd, screen, or ???)
                    GP_PID=`${PS} -p ${P_PID} -o ppid=`

                    #!${ECHO} "P_PID=${P_PID}, GP_PID=${GP_PID}"

                    # Get the screen PIDs
                    S_PIDS=`${PGREP} screen`
                
                    for s_pid in ${S_PIDS} ; do
                        #!${ECHO} ${s_pid}

                        if [ ${s_pid} -eq ${P_PID} ] ; then
                            SCREEN_PID=${s_pid}
                            RUNNING_IN=screen
                            break
                        fi
                
                        if [ ${s_pid} -eq ${GP_PID} ] ; then
                            SCREEN_PID=${s_pid}
                            RUNNING_IN=screen
                            break
                        fi
                    
                    done
                    
                    # Get the procServ PIDs
                    PS_PIDS=`${PGREP} procServ`
                    
                    for ps_pid in ${PS_PIDS} ; do
                        #!${ECHO} ${ps_pid}
                        
                        if [ ${ps_pid} -eq ${P_PID} ] ; then
                            PROCSERV_PID=${ps_pid}
                            RUNNING_IN=procServ
                            SAME_HOST=True
                            # Read the procServ endpoint info
                            parse_procServ_info ${IOC_STARTUP_DIR}/${PROCSERV_INFO_FILE}
                            break
                        fi
                        
                        if [ ${ps_pid} -eq ${GP_PID} ] ; then
                            PROCSERV_PID=${ps_pid}
                            RUNNING_IN=procServ
                            SAME_HOST=True
                            # Read the procServ endpoint info
                            parse_procServ_info ${IOC_STARTUP_DIR}/${PROCSERV_INFO_FILE}
                            break
                        fi
                    
                    done
                    
                    #!echo "SCREEN_PID=${SCREEN_PID}"
                    #!echo "PROCSERV_PID=${PROCSERV_PID}"
                else
                    # Assume the script is being called from the IOC host
                    SAME_HOST=True
                    parse_procServ_info ${IOC_STARTUP_DIR}/${PROCSERV_INFO_FILE}
                    if [ ! -z ${PROCSERV_PID} ] ; then
                        RUNNING_IN=procServ
                    else
                        RUNNING_IN=screen
                    fi
                fi
                
                break
            
            #else
            #    ${ECHO} "PATHS are different"
            #    ${ECHO} ${BIN_CWD}
            #    ${ECHO} ${IOC_CWD}
            fi
        done
    else
        # The hasn't started yet (procServ's -w option) or it is running on a different computer
        if [ ! -z ${PROCSERV_INFO_FILE} ] ; then
            if [ -f "${IOC_STARTUP_DIR}/${PROCSERV_INFO_FILE}" ] ; then
                # A procServ instance is running for this IOC
                IOC_DOWN=0
                RUNNING_IN=procServ
                IOC_PID=TBD
                
                # Get the procServ PID
                parse_procServ_info ${IOC_STARTUP_DIR}/${PROCSERV_INFO_FILE}
                
                # Get the procServ PIDs
                PS_PIDS=`${PGREP} procServ`
                
                # Get the instances of procServ on this computer
                for ps_pid in ${PS_PIDS}
                do
                    #!${ECHO} ${ps_pid}
                    if [ ${ps_pid} -eq ${PROCSERV_PID} ] ; then
                        # This script is running on the computer with the procServ instance that will eventually run the IOC
                        SAME_HOST=True
                        break
                    fi
                done
            else
                # procServ isn't running
                IOC_DOWN=1
            fi
        else
            # IOC is not running
            IOC_DOWN=1
        fi
    fi

    return ${IOC_DOWN}
}

get_random_port() {
    # Get a random port for procServ
    while :
    do
        i=$(( $RANDOM % $NUM_PORTS + $START ))
        ${NC} -z localhost $i
        if [ $? ]
        then
            echo "$i"
            break
        fi
    done
}

ioc_cmd() {	
	CMD=$1
	VAL=0
	
	CMD_ARGS=()
	
	if [ $# -lt 1 ] ; then
		CMD="usage"
	fi
	
	if [ $# -gt 1 ] ; then
		CMD_ARGS=${@:2:$(($#-1))}
	fi
	
	for i in "${REGISTERED_CMD_NAMES[@]}"; do
		if [ $i == "$CMD" ] ;  then
			${REGISTERED_CMD_FUNCS[$VAL]} $CMD_ARGS
			return
		fi
		
		VAL=$((VAL+1))
	done
	
	${ECHO} "${CMD} not a recognized command"
}

for file in ${IOC_COMMAND_DIR}/*; do
	source $file
done


#####################################################################

if [ ! -d ${IOC_STARTUP_DIR} ] ; then
    ${ECHO} "Error: ${IOC_STARTUP_DIR} doesn't exist."
    ${ECHO} "IOC_STARTUP_DIR in ${SNAME} needs to be corrected."
else
	ioc_cmd $SELECTION $SEL_ARGS
fi
