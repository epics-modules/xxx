
# BEGIN serial.cmd ------------------------------------------------------------

# Set up 2 local serial ports
#drvAsynSerialPortConfigure("portName","ttyName",priority,noAutoConnect,
#                            noProcessEos)
drvAsynSerialPortConfigure("serial1", "/dev/ttyS0", 0, 0, 0)
drvAsynSerialPortConfigure("serial2", "/dev/ttyS1", 0, 0, 0)

# Set up 2 MOXA Nport serial ports
#drvAsynIPPortConfigure("serial3", "164.54.160.50:4001", 0, 0, 0)
#drvAsynIPPortConfigure("serial4", "164.54.160.50:4002", 0, 0, 0)

# Make port available from the iocsh command line
#asynOctetConnect(const char *entry, const char *port, int addr,
#                 int timeout, int buffer_len, const char *drvInfo)
asynOctetConnect("serial1", "serial1")
asynOctetConnect("serial2", "serial2")
#asynOctetConnect("serial3", "serial3")
#asynOctetConnect("serial4", "serial4")

# Load asynRecord and deviceCmdReply records for ports
iocshLoad("$(IP)/iocsh/loadSerialComm.iocsh", "P=$(PREFIX), PORT0=serial1, PORT1=serial2, PORT2=serial3, PORT4=serial4")


# serial 1 connected to Keithley2K DMM at 19200 baud
#iocshLoad("$(IP)/iocsh/Keithley_2k_serial.iocsh", "PREFIX=$(PREFIX), INSTANCE=D1, PORT=serial1, NUM_CHANNELS=22, MODEL=2700")

# serial 2 connected to Newport MM4000 at 38400 baud
iocshLoad("$(MOTOR)/iocsh/Newport_MM4000.iocsh", "PORT=serial2, CONTROLLER=0, POLL_RATE=10, MAX_CONTROLLERS=1")

# serial 3 is connected to the ACS MCB-4B at 9600 baud
iocshLoad("$(MOTOR)/iocsh/ACS_MCB4B.iocsh", "PORT=serial3, CONTROLLER=0, POLL_RATE=100, NUM_AXES=1")
#iocshLoad("$(MOTOR)/iocsh/Newport_PM500.iocsh",  "PORT=serial3, CONTROLLER=0, POLL_RATE=10, MAX_CONTROLLERS=1")

# serial 4 not connected for now
#iocshLoad("$(MOTOR)/iocsh/McClennan_PM304.iocsh", "PORT=serial4, CONTROLLER=0, POLL_RATE=10, MAX_CONTROLLERS=1, NUM_AXES=1")

# Stanford Research Systems SR570 Current Preamplifier
#iocshLoad("$(IP)/iocsh/SR_570.iocsh", "PREFIX=$(PREFIX), INSTANCE=A1, PORT=serial1")

# Lakeshore DRC-93CA Temperature Controller
#iocshLoad("$(IP)/iocsh/Lakeshore_DRC93CA.iocsh", "PREFIX=$(PREFIX), INSTANCE=TC1, PORT=serial4")

# Huber DMC9200 DC Motor Controller
#dbLoadRecords("$(IP)/ipApp/Db/HuberDMC9200.db", "P=$(PREFIX),Q=DMC1:,PORT=serial5")

# Oriel 18011 Encoder Mike
#dbLoadRecords("$(IP)/ipApp/Db/eMike.db", "P=$(PREFIX),M=em1,PORT=serial3")

# Oxford Cyberstar X1000 Scintillation detector and pulse processing unit
#iocshLoad("$(IP)/iocsh/Oxford_X1k.iocsh", "PREFIX=$(PREFIX), INSTANCE=s1, PORT=serial4")

# Oxford ILM202 Cryogen Level Meter (Serial)
#iocshLoad("$(IP)/iocsh/Oxford_ILM202.iocsh", "PREFIX=$(PREFIX), INSTANCE=s1, PORT=serial5")

# Eurotherm temp controller
#dbLoadRecords("$(IP)/ipApp/Db/Eurotherm.db","P=$(PREFIX),PORT=serial7")

# MKS vacuum gauges
#dbLoadRecords("$(IP)/ipApp/Db/MKS.db","P=$(PREFIX),PORT=serial2,CC1=cc1,CC2=cc3,PR1=pr1,PR2=pr3")

# PI Digitel 500/1500 pump
#dbLoadRecords("$(IP)/ipApp/Db/Digitel.db","$(PREFIX),PUMP=ip1,PORT=serial3")

# PI MPC ion pump
#dbLoadRecords("$(IP)/ipApp/Db/MPC.db","P=$(PREFIX),PUMP=ip2,PORT=serial4,PA=0,PN=1")

# PI MPC TSP (titanium sublimation pump)
#dbLoadRecords("$(IP)/ipApp/Db/TSP.db","P=$(PREFIX),TSP=tsp1,PORT=serial4,PA=0")

# Heidenhain ND261 encoder (for PSL monochromator)
#iocshLoad("$(IP)/iocsh/Heidenhain_ND261.iocsh", "PREFIX=$(PREFIX), PORT=serial1")

# END serial.cmd --------------------------------------------------------------
