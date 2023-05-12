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
# The absolute path to the directory containing the IOC's bin directory, if running an example IOC binary
#!IOC_BIN_DIR=/home/username/epics/synApps/support/xxx/bin
#!IOC_BIN_DIR=/home/username/epics/synApps/support/module/iocs/exampleIOC/bin

# uncomment for your OS here (comment out all the others)
#IOC_STARTUP_FILE="st.cmd.Cygwin"
IOC_STARTUP_FILE="st.cmd.Linux"
#IOC_STARTUP_FILE="st.cmd.vxWorks"
#IOC_STARTUP_FILE="st.cmd.Win32"
#IOC_STARTUP_FILE="st.cmd.Win64"

# Change YES to NO in the following line to disable screen-PID lookup, which isn't supported on Windows
GET_SCREEN_PID=YES

# Commands needed by this script
ECHO=echo
ID=id
GREP=grep
PGREP=pgrep
SCREEN=screen
KILL=kill
BASENAME=basename
DIRNAME=dirname
READLINK=readlink
PS=ps
#
PROCSERV=/APSshare/bin/procServ
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

SNAME=$(cd "$(dirname "$BASH_SOURCE")"; cd -P "$(dirname "$(readlink "$BASH_SOURCE" || echo .)")"; pwd)
SELECTION=$1

SEL_ARGS=()

if [ $# -gt 1 ] ; then
	SEL_ARGS=${@:2:$(($#-1))}
fi

if [ -z "$IOC_STARTUP_DIR" ] ; then	
    # If no startup dir is specified, use the directory above the script's directory
    IOC_STARTUP_DIR=${SNAME}/..
    
    IOC_STARTUP_FILE_PATH="${IOC_STARTUP_FILE}"
else
    IOC_STARTUP_FILE_PATH="${IOC_STARTUP_DIR}/${IOC_STARTUP_FILE}"
fi
#!${ECHO} ${IOC_STARTUP_DIR}

if [ -z "$IOC_BIN_DIR" ] ; then
    IOC_BIN_PATH="${IOC_STARTUP_DIR}/../../bin/${EPICS_HOST_ARCH}/${IOC_BINARY}"
else
    IOC_BIN_PATH="${IOC_BIN_DIR}/${EPICS_HOST_ARCH}/${IOC_BINARY}"
fi
#!${ECHO} ${IOC_BIN_PATH}

IOC_CMD="${IOC_BIN_PATH} ${IOC_STARTUP_FILE_PATH}"
#!${ECHO} ${IOC_CMD}

if [ -z "$IOC_COMMAND_DIR" ] ; then
	IOC_COMMAND_DIR="${SNAME}/commands"
fi


PROCSERV_INFO=()
NUM_DEFAULTS=5

INFO_COMMAND=$(($NUM_DEFAULTS * 0))
INFO_CONSOLE=$(($NUM_DEFAULTS * 1))

INFO_PREFIX=0
INFO_PORT=1
INFO_PID=2
INFO_IP=3
INFO_SAME_HOST=4

# Command Port Default Info
PROCSERV_INFO[$INFO_COMMAND + $INFO_PREFIX]=ioc${IOC_NAME}-command
PROCSERV_INFO[$INFO_COMMAND + $INFO_PORT]=-1
PROCSERV_INFO[$INFO_COMMAND + $INFO_PID]=-1
PROCSERV_INFO[$INFO_COMMAND + $INFO_IP]=-1
PROCSERV_INFO[$INFO_COMMAND + $INFO_SAME_HOST]=0

# Console Port Default Info
PROCSERV_INFO[$INFO_CONSOLE + $INFO_PREFIX]=ioc${IOC_NAME}-console
PROCSERV_INFO[$INFO_CONSOLE + $INFO_PORT]=-1
PROCSERV_INFO[$INFO_CONSOLE + $INFO_PID]=-1
PROCSERV_INFO[$INFO_CONSOLE + $INFO_IP]=-1
PROCSERV_INFO[$INFO_CONSOLE + $INFO_SAME_HOST]=0


# This variable will be used to perform the correct function for a given argument
RUNNING_IN=TBD
REMOTE_COMMAND=TBD
REMOTE_CONSOLE=TBD

#####################################################################

REGISTERED_CMD_NAMES=()
REGISTERED_CMD_FUNCS=()

REMOTE_CMD_NAMES=()
REMOTE_CMD_FUNCS=()

register() {
	CMD_NAME=$1
	CMD_FUNC=$2
	
	INTERNAL=${3:-local}
	
	if [ $INTERNAL == "remote" ] ; then
		REMOTE_CMD_NAMES+=("$CMD_NAME")
		REMOTE_CMD_FUNCS+=("$CMD_FUNC")
	else
		REGISTERED_CMD_NAMES+=("$CMD_NAME")
		REGISTERED_CMD_FUNCS+=("$CMD_FUNC")
	fi
}

checkpid() {
	# Assume the IOC is down until proven otherwise
	IOC_DOWN=1
	
    MY_UID=`${ID} -u`
    # The '\$' is needed in the pgrep pattern to select xxx, but not xxx.sh
    IOC_PID=`${PGREP} ${IOC_BINARY}\$ -u ${MY_UID}`
    
	
    if [ "${IOC_PID}" != "" ] ; then

        # At least one instance of the IOC binary is running; 
        # Find the binary that is associated with this script/IOC
        for pid in ${IOC_PID}; do
			# Check if a process with the given PID has been run in the current startup directory
			BIN_CHECK=`${PS} aux | ${GREP} "${pid}" | ${GREP} "${IOC_CMD}"`
			
			if [[ ! -z "$BIN_CHECK" ]] ; then
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
                        ${ECHO} ${s_pid}

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
                    
                    #!echo "SCREEN_PID=${SCREEN_PID}"
                    #!echo "PROCSERV_PID=${PROCSERV_PID}"
                fi
                
                break
            
            #else
            #    ${ECHO} "PATHS are different"
            #    ${ECHO} ${BIN_CWD}
            #    ${ECHO} ${IOC_CWD}
            fi
        done
    fi

    return ${IOC_DOWN}
}


psinfo() {
	START=$1
	VALUE=$2
	
	echo "${PROCSERV_INFO[$START + $VALUE]}"
}

parse_procServ_info() {
	START=$1

	CHECK_FILE="${PROCSERV_INFO[$START + $INFO_PREFIX]}.txt"

	
	if [ ! -z ${CHECK_FILE} ] ; then
        # function was called with an argument
        if [ -f "${CHECK_FILE}" ] ; then
            # info file exists
            #!${ECHO} "INFO_FILE = $CHECK_FILE"
            
            # Get PID
			PROCSERV_INFO[$START + $INFO_PID]=$(${HEAD} -n 1 ${CHECK_FILE} | cut -d ':' -f 2)
			#!${ECHO} ${PROCSERV_PID}
            
            # Get control endpoint
            CTL_STR=$(${TAIL} -n 1 ${CHECK_FILE})
            if [ $(${ECHO} ${CTL_STR} | ${CUT} -d ':' -f 1) == 'tcp' ]; then
                # tcp control endpoint; port is 3rd item
				PROCSERV_INFO[$START + $INFO_IP]=$(${ECHO} ${CTL_STR} | ${CUT} -d ':' -f 2)
                PROCSERV_INFO[$START + $INFO_PORT]=$(${ECHO} ${CTL_STR} | ${CUT} -d ':' -f 3)
                #!${ECHO} ${PROCSERV_PORT}
            else
                # unix control endpoint; socket is 2nd item
                PROCSERV_INFO[$START + $INFO_SOCKET]=$(${ECHO} ${CTL_STR} | ${CUT} -d ':' -f 2)
                #!${ECHO} ${PROCSERV_SOCKET}
            fi
			
			PROCSERV_INFO[$START + $INFO_SAME_HOST]=`ifconfig | ${GREP} -o ${PROCSERV_INFO[$START + $INFO_IP]} | grep -c "^"`
        fi
    fi
}

can_ping() {
	WHICH=$1
	
	if [[ $(psinfo $WHICH $INFO_IP) != "-1" ]] ; then
		OPEN=`nc -z $(psinfo $WHICH $INFO_IP) $(psinfo $WHICH $INFO_PORT); echo $?`
	
		if [[ $OPEN -eq 0 ]] ; then
			return 0
		fi
	fi
	
	return 1
}

has_remote() {
	if [[ $(psinfo $INFO_COMMAND $INFO_IP) != "-1" ]] ; then
		return 0
	fi
	
	return 1
}

is_local() {
	if has_remote; then
		if [[ $(psinfo $INFO_COMMAND $INFO_SAME_HOST) -eq 0 ]] ; then
			return 1
		fi
	fi
	
	return 0
}

ioc_up() {
	if has_remote; then
		if $(can_ping $INFO_CONSOLE); then
			return 0
		fi
	else
		if checkpid; then
			return 0
		fi
	fi
	
	return 1
}

	

update_psinfo() {
	#refresh softioc folder to make sure procServ info files are loaded
	ls >> /dev/null
	
	parse_procServ_info $INFO_COMMAND
	parse_procServ_info $INFO_CONSOLE
	
	
	if [[ $(psinfo $INFO_COMMAND $INFO_PID) != "-1" ]] ; then
		if ! $(can_ping $INFO_COMMAND) ; then
			${ECHO} "ProcServ file open for command server, but cannot access IP/Port"
		fi
	fi
	
	if [[ $(psinfo $INFO_CONSOLE $INFO_PID) != "-1" ]] ; then
		if ! $(can_ping $INFO_CONSOLE) ; then
			${ECHO} "ProcServ file open for console server, but cannot access IP/Port"
		fi
	fi
}



send_command() {
	START=$1
	CMD=${@:2:$(($#-1))}
	
	${ECHO} "$CMD" | nc $(psinfo $START $INFO_IP) $(psinfo $START $INFO_PORT) >> /dev/null
}


screenpid() {
    if [ ! -z ${SCREEN_PID} ] ; then
        ${ECHO} " in a screen session (pid=${SCREEN_PID})"
    else
        ${ECHO} 
    fi
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

remote_cmd() {	
	CMD=$1
	VAL=0
	
	CMD_ARGS=()
	
	if [ $# -lt 1 ] ; then
		CMD="usage"
	fi
	
	if [ $# -gt 1 ] ; then
		CMD_ARGS=${@:2:$(($#-1))}
	fi
	
	for i in "${REMOTE_CMD_NAMES[@]}"; do
		if [ $i == "$CMD" ] ;  then
			${REMOTE_CMD_FUNCS[$VAL]} $CMD_ARGS
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
update_psinfo

if [ ! -d ${IOC_STARTUP_DIR} ] ; then
    ${ECHO} "Error: ${IOC_STARTUP_DIR} doesn't exist."
    ${ECHO} "IOC_STARTUP_DIR in ${SNAME} needs to be corrected."
else
	ioc_cmd $SELECTION $SEL_ARGS
fi
