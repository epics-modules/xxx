cd ""
< ../nfsCommands
< cdCommands
< MPFconfig.cmd

cd topbin
cd "../vxWorks-68040"
ld < xxx.munch

cd startup
#start message router
routerInit
tcpMessageRouterServerStart(1, 9900, Remote_IP, 1500, 40)

< st_mpfserver.cmd

shellPromptSet "iocxxx1> "

