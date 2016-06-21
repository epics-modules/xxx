#!/bin/sh
#
# description: start/stop/restart an EPICS IOC in a screen session
#

# Manually set IOC_STARTUP_DIR if xxx.sh will reside somewhere other than iocxxx
#!IOC_STARTUP_DIR=/home/username/epics/ioc/synApps/xxx/iocBoot/iocxxx

# Set EPICS_HOST_ARCH if the env var isn't already set properly for this IOC
#!EPICS_HOST_ARCH=linux-x86_64
#!EPICS_HOST_ARCH=linux-x86_64-debug

IOC_NAME=xxx
# The name of the IOC binary isn't necessarily the same as the name of the IOC
IOC_BINARY=xxx

# Change YES to NO in the following line to disable screen-PID lookup 
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

SNAME=$0
SELECTION=$1

if [ -z "$IOC_STARTUP_DIR" ]
then
    # If no startup dir is specified, assume this script resides in the IOC's startup directory
    IOC_STARTUP_DIR="$(${DIRNAME} ${SNAME})"
fi
#!${ECHO} ${IOC_STARTUP_DIR}

#####################################################################

IOC_CMD="../../bin/${EPICS_HOST_ARCH}/${IOC_BINARY} st.cmd"

screenpid() {
        if [ -z ${SCREEN_PID} ] ; then
	    ${ECHO}
	else
	    ${ECHO} " in a screen session (pid=${SCREEN_PID})"
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
	    
	    if [ "$BIN_CWD" == "$IOC_CWD" ] ; then
		# The IOC is running; the binary with PID=$pid is the IOC that was run from $IOC_STARTUP_DIR
		IOC_PID=${pid}
		IOC_DOWN=0
		
		SCREEN_PID=""

                if [ "${GET_SCREEN_PID}" == "YES" ]
		then
		    # Get the PID of the parent of the IOC (shell or screen)
		    P_PID=`${PS} -p ${IOC_PID} -o ppid=`
		    
		    # Get the PID of the grandparent of the IOC (sshd, screen, or ???)
		    GP_PID=`${PS} -p ${P_PID} -o ppid=`

		    #!${ECHO} "P_PID=${P_PID}, GP_PID=${GP_PID}"

		    # Get the screen PIDs
		    S_PIDS=`${PGREP} screen`
		
		    for s_pid in ${S_PIDS}
		    do
		        #!${ECHO} ${s_pid}

		        if [ "${s_pid}" == "${P_PID}" ] ; then
			    SCREEN_PID=${s_pid}
			    break
	                fi
		
		        if [ "${s_pid}" == "${GP_PID}" ] ; then
			    SCREEN_PID=${s_pid}
			    break
	                fi
		
		    done
		fi
		
		break
	    #else
	    #    ${ECHO} "PATHS are different"
	    #    ${ECHO} ${BIN_CWD}
	    #    ${ECHO} ${IOC_CWD}
	    fi
	done
    else
        # IOC is not running
	IOC_DOWN=1
    fi

    return ${IOC_DOWN}
}

start() {
    if checkpid; then
        ${ECHO} -n "${IOC_NAME} is already running (pid=${IOC_PID})"
	screenpid
    else
        ${ECHO} "Starting ${IOC_NAME}"
        cd ${IOC_STARTUP_DIR}
	# Run xxx inside a screen session
	${SCREEN} -dm -S ${IOC_NAME} -h 5000 ${IOC_CMD}
    fi
}

stop() {
    if checkpid; then
        ${ECHO} "Stopping ${IOC_NAME} (pid=${IOC_PID})"
	${KILL} ${IOC_PID}
    else
        ${ECHO} "${IOC_NAME} is not running"
    fi
}

restart() {
    stop
    start
}

status() {
    if checkpid; then
        ${ECHO} -n "${IOC_NAME} is running (pid=${IOC_PID})"
        screenpid
    else
        ${ECHO} "${IOC_NAME} is not running"
    fi
}

console() {
    if checkpid; then
        ${ECHO} "Connecting to ${IOC_NAME}'s screen session"
	# The -r flag will only connect if no one is attached to the session
	#!${SCREEN} -r ${IOC_NAME}
	# The -x flag will connect even if someone is attached to the session
	${SCREEN} -x ${IOC_NAME}
    else
        ${ECHO} "${IOC_NAME} is not running"
    fi
}

run() {
    if checkpid; then
        ${ECHO} -n "${IOC_NAME} is already running (pid=${IOC_PID})"
	screenpid
    else
        ${ECHO} "Starting ${IOC_NAME}"
        cd ${IOC_STARTUP_DIR}
	# Run xxx outside of a screen session, which is helpful for debugging
	${IOC_CMD}
    fi
}

usage() {
    ${ECHO} "Usage: $(${BASENAME} ${SNAME}) {start|stop|restart|status|console|run}"
}

#####################################################################

if [ ! -d ${IOC_STARTUP_DIR} ]
then
    ${ECHO} "Error: ${IOC_STARTUP_DIR} doesn't exist."
    ${ECHO} "IOC_STARTUP_DIR in ${SNAME} needs to be corrected."
else
    case ${SELECTION} in
        start)
	    start
	    ;;

        stop | kill)
	    stop
	    ;;

        restart)
	    restart
	    ;;

        status)
	    status
	    ;;
	
        console)
            console
	    ;;

        run)
            run
	    ;;

        *)
	    usage
	    ;;
    esac
fi
