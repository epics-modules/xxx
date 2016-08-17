
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
tyGSOctalDevCreate("serial0", "UART_0", 0, 1000, 1000)
tyGSOctalDevCreate("serial1", "UART_0", 1, 1000, 1000)
tyGSOctalDevCreate("serial2", "UART_0", 2, 1000, 1000)
tyGSOctalDevCreate("serial3", "UART_0", 3, 1000, 1000)
tyGSOctalDevCreate("serial4", "UART_0", 4, 1000, 1000)
tyGSOctalDevCreate("serial5", "UART_0", 5, 1000, 1000)
tyGSOctalDevCreate("serial6", "UART_0", 6, 1000, 1000)
tyGSOctalDevCreate("serial7", "UART_0", 7, 1000, 1000)

#serial0 - SR570
#serial1 - 
#serial2 - Newport PM500
#serial3 - 
#serial4 - ACS MCB-4B
#serial5 - 
#serial6 - Newport MM4000
#serial7 - Love Controllers


# Newport MM4000 driver setup parameters:
#     (1) maximum # of controllers,
#     (2) motor task polling rate (min=1Hz, max=60Hz)
#MM4000Setup(1, 10)

# Newport MM4000 serial connection settings
#asynSetOption("serial6", -1, "baud", "38400")
#asynSetOption("serial6", -1, "bits", "8")
#asynSetOption("serial6", -1, "stop", "1")
#asynSetOption("serial6", -1, "parity", "none")
#asynSetOption("serial6", -1, "clocal", "Y")
#asynSetOption("serial6", -1, "crtscts", "N")
#asynOctetSetInputEos("serial6", -1, "\r")
#asynOctetSetOutputEos("serial6", -1, "\r")

# Newport MM4000 driver configuration parameters:
#     (1) controller
#     (2) asyn port name (e.g. serial0 or gpib1)
#     (3) GPIB address (0 for serial)
#MM4000Config(0, "serial6", 0)

# Newport PM500 driver setup parameters:
#     (1) maximum number of controllers in system
#     (2) motor task polling rate (min=1Hz,max=60Hz)
#PM500Setup(1, 10)

# Newport PM500 serial connection settings
#asynSetOption("serial2", -1, "baud", "9600")
#asynSetOption("serial2", -1, "bits", "7")
#asynSetOption("serial2", -1, "stop", "2")
#asynSetOption("serial2", -1, "parity", "even")
#asynSetOption("serial2", -1, "clocal", "N")  # Hardware handshaking
#asynSetOption("serial2", -1, "crtscts", "N")
#asynOctetSetInputEos("serial2", -1, "\r")
#asynOctetSetOutputEos("serial2", -1, "\r")

# Newport PM500 configuration parameters:
#     (1) controller
#     (2) asyn port name (e.g. serial0 or gpib1)
#PM500Config(0, "serial2")

# McClennan PM304 driver setup parameters:
#     (1) maximum number of controllers in system
#     (2) motor task polling rate (min=1Hz, max=60Hz)
#PM304Setup(1, 10)

# McClennan PM304 driver configuration parameters:
#     (1) controller being configured
#     (2) MPF serial server name (string)
#     (3) Number of axes on this controller
#PM304Config(0, "serial3", 1)

# ACS MCB-4B driver setup parameters:
#     (1) maximum number of controllers in system
#     (2) motor task polling rate (min=1Hz, max=60Hz)
#MCB4BSetup(1, 10)

# ACS MCB-4B serial connection settings
#asynSetOption("serial4", -1, "baud", "19200")
#asynSetOption("serial4", -1, "bits", "8")
#asynSetOption("serial4", -1, "stop", "1")
#asynSetOption("serial4", -1, "parity", "none")
#asynSetOption("serial4", -1, "clocal", "Y")
#asynSetOption("serial4", -1, "crtscts", "N")
#asynOctetSetInputEos("serial4", -1, "\r")
#asynOctetSetOutputEos("serial4", -1, "\r")

# ACS MCB-4B driver configuration parameters:
#     (1) controller being configured
#     (2) asyn port name (string)
#MCB4BConfig(0, "serial4")

# Load asynRecord records on all ports
dbLoadTemplate("asynRecord.substitutions")

# send impromptu message to serial device, parse reply
# (was serial_OI_block)
dbLoadRecords("$(IP)/ipApp/Db/deviceCmdReply.db","P=$(PREFIX),N=1,PORT=serial0,ADDR=0,OMAX=100,IMAX=100")

# Stanford Research Systems SR570 Current Preamplifier
#asynSetOption("serial0", -1, "baud", "9600")
#asynSetOption("serial0", -1, "bits", "8")
#asynSetOption("serial0", -1, "stop", "2")
#asynSetOption("serial0", -1, "parity", "none")
#asynSetOption("serial0", -1, "clocal", "Y")
#asynSetOption("serial0", -1, "crtscts", "N")
#asynOctetSetInputEos("serial0", -1, "\r")
#asynOctetSetOutputEos("serial0", -1, "\r")
#dbLoadRecords("$(IP)/ipApp/Db/SR570.db", "P=$(PREFIX),A=A1,PORT=serial0")

# Keithley 2000 DMM
#dbLoadRecords("$(IP)/ipApp/Db/Keithley2kDMM_mf.db","P=$(PREFIX),Dmm=D1,PORT=serial0")
# channels: 10, 20, or 22;  model: 2000 or 2700
#doAfterIocInit("seq &Keithley2kDMM,('P=$(PREFIX), Dmm=D1, channels=22, model=2700')")
#doAfterIocInit("seq &Keithley2kDMM,('P=$(PREFIX), Dmm=D2, channels=10, model=2000')")

# Oxford Cyberstar X1000 Scintillation detector and pulse processing unit
#dbLoadRecords("$(IP)/ipApp/Db/Oxford_X1k.db","P=$(PREFIX),S=s1,PORT=serial3")

# Oxford ILM202 Cryogen Level Meter (Serial)
#dbLoadRecords("$(IP)/ipApp/Db/Oxford_ILM202.db","P=$(PREFIX),S=s1,PORT=serial4")

# END serial.cmd --------------------------------------------------------------
