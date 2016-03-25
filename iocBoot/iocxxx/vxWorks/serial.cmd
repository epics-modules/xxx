
# BEGIN serial.cmd ------------------------------------------------------------

# Initialize Octal UART stuff
# tyGSOctalDrv(int maxModules)
tyGSOctalDrv(1)

# tyGSOctalModuleInit(char *name, char *type, int intVec, int carrier, int slot)
# name    - name by which you want to refer to this IndustryPack module
# type    - one of "232", "422", "485" -- the serial hardware standard the module implements
# intVec  - interrupt vector 
# carrier - number of IP carrier (Carriers are numbered in the order in which they were
#           defined in ipacAddXYZ() calls.)
# slot    - location of module on carrier -- 0..3 for slot A..slot D
tyGSOctalModuleInit("UART_0", "232", 0x80, 0, 0)

# int tyGSAsynInit(char *port, char *moduleName, int channel, int baud,
# char parity, int sbits, int dbits, char handshake, 
# char *inputEos, char *outputEos)
tyGSAsynInit("serial1",  "UART_0", 0, 9600,'N',2,8,'N',"\r","\r")  /* SRS570 */
tyGSAsynInit("serial2",  "UART_0", 1, 9600,'E',1,7,'N',"\r\n","\r\n")  /*  */
tyGSAsynInit("serial3",  "UART_0", 2, 9600,'E',1,7,'N',"","\n")  /* Digitel */
tyGSAsynInit("serial4",  "UART_0", 3, 9600,'N',1,8,'N',"\n","\n")  /* MPC */
tyGSAsynInit("serial5",  "UART_0", 4,19200,'N',1,8,'N',"\r","\r")  /* ACS MCB-4B */
tyGSAsynInit("serial6",  "UART_0", 5, 9600,'N',1,8,'N',"\r\n","\r") /* XIA slit */
tyGSAsynInit("serial7",  "UART_0", 6,38400,'N',1,8,'N',"\r","\r")  /* Newport MM4000 */
tyGSAsynInit("serial8",  "UART_0", 7,19200,'N',1,8,'N',"","")      /* Love controllers */

# Newport MM4000 driver setup parameters:
#     (1) maximum # of controllers,
#     (2) motor task polling rate (min=1Hz, max=60Hz)
#MM4000Setup(1, 10)

# Newport MM4000 driver configuration parameters:
#     (1) controller
#     (2) asyn port name (e.g. serial1 or gpib1)
#     (3) GPIB address (0 for serial)
#MM4000Config(0, "serial7", 0)

# Newport PM500 driver setup parameters:
#     (1) maximum number of controllers in system
#     (2) motor task polling rate (min=1Hz,max=60Hz)
#PM500Setup(1, 10)

# Newport PM500 configuration parameters:
#     (1) controller
#     (2) asyn port name (e.g. serial1 or gpib1)
#PM500Config(0, "serial3")

# McClennan PM304 driver setup parameters:
#     (1) maximum number of controllers in system
#     (2) motor task polling rate (min=1Hz, max=60Hz)
#PM304Setup(1, 10)

# McClennan PM304 driver configuration parameters:
#     (1) controller being configured
#     (2) MPF serial server name (string)
#     (3) Number of axes on this controller
#PM304Config(0, "serial4", 1)

# ACS MCB-4B driver setup parameters:
#     (1) maximum number of controllers in system
#     (2) motor task polling rate (min=1Hz, max=60Hz)
#MCB4BSetup(1, 10)

# ACS MCB-4B driver configuration parameters:
#     (1) controller being configured
#     (2) asyn port name (string)
#MCB4BConfig(0, "serial5")

# Load asynRecord records on all ports
dbLoadTemplate("asynRecord.substitutions")

# send impromptu message to serial device, parse reply
# (was serial_OI_block)
dbLoadRecords("$(IP)/ipApp/Db/deviceCmdReply.db","P=xxx:,N=1,PORT=serial1,ADDR=0,OMAX=100,IMAX=100")

# Stanford Research Systems SR570 Current Preamplifier
#dbLoadRecords("$(IP)/ipApp/Db/SR570.db", "P=xxx:,A=A1,PORT=serial1")

# Keithley 2000 DMM
#dbLoadRecords("$(IP)/ipApp/Db/Keithley2kDMM_mf.db","P=xxx:,Dmm=D1,PORT=serial1")
# channels: 10, 20, or 22;  model: 2000 or 2700
#doAfterIocInit("seq &Keithley2kDMM,('P=xxx:, Dmm=D1, channels=22, model=2700')")
#doAfterIocInit("seq &Keithley2kDMM,('P=xxx:, Dmm=D2, channels=10, model=2000')")

# Oxford Cyberstar X1000 Scintillation detector and pulse processing unit
#dbLoadRecords("$(IP)/ipApp/Db/Oxford_X1k.db","P=xxx:,S=s1,PORT=serial4")

# Oxford ILM202 Cryogen Level Meter (Serial)
#dbLoadRecords("$(IP)/ipApp/Db/Oxford_ILM202.db","P=xxx:,S=s1,PORT=serial5")

# Love Controllers
#devLoveDebug=1
#loveServerDebug=1
#dbLoadRecords("$(IP)/ipApp/Db/love.db", "P=xxx:,Q=Love_0,C=0,PORT=PORT2,ADDR=1")

# END serial.cmd --------------------------------------------------------------
