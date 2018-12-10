
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
iocshLoad("$(IP)/iocsh/loadSerialComm.iocsh", "P=$(PREFIX), PORT0=serial1, PORT1=serial2, PORT2=serial3, PORT3=serial4")

# END serial.cmd --------------------------------------------------------------
