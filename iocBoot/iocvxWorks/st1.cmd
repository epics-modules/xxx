cd ""
< ../nfsCommands
< cdCommands
< MPFconfig.cmd

cd appbin
cd ../vxWorks-68040
ld < mpfLib
ld < ipLib
ld < mpfserialserverLib
# Uncomment, as needed.
#ld < mpfgpibserverLib
ld < dac128VLib

cd startup
#start message router
routerInit
tcpMessageRouterServerStart(1, 9900, Remote_IP, 1500, 40)

< st_mpfserver.cmd

shellPromptSet "iocxxx1> "

