# FILENAME: st1.cmd
# USAGE:    VxWorks startup script for Auxiliary (Non-EPICS) processor.

cd ""
< ../nfsCommands
# Nore we're loading the cdCommands file that was built for the main
# EPICS processor, which may be of a different architecture. 
< cdCommands
< MPFconfig.cmd

cd appbin
# appbin might point to a different architecture than we need
cd "../mv167"
ld < mpfLib
ld < ipLib
ld < mpfserialserverLib
# Uncomment, as needed.
#ld < mpfgpibserverLib
#ld < dac128VLib

cd startup
#start message router
routerInit
tcpMessageRouterServerStart(1, 9900, Remote_IP, 1500, 40)

< st1_mpfserver.cmd

shellPromptSet "iocxxx1> "

