# FILENAME: st1.cmd
# USAGE:    VxWorks startup script for Auxiliary (Non-EPICS) processor.

cd ""
< ../nfsCommands
< cdCommands.68K
< MPFconfig.cmd

cd appbin
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

< st_mpfserver.cmd

shellPromptSet "iocxxx1> "

