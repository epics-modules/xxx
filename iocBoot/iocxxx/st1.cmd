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
localMessageRouterStart(0)
tcpMessageRouterServerStart(1, 9900, Remote_IP, 1500, 40)

< st_mpfserver.cmd

shellPromptSet "iocxxx1> "

