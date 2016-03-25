
# BEGIN gpib.cmd ------------------------------------------------------------

# SBS IP488 GPIB
# gsIP488Configure(char *portName, int carrier, int module, int vector,
#                  unsigned int priority, int noAutoConnect)
#     portName      - An ascii string specifying the port name that will be
#                     registered with asynDriver.
#     carrier       - An integer identifying the Industry Pack Carrier (numbered
#                     from 0)
#     module        - An integer identifying the module on the carrier (numbered
#                     from 0)
#     intVec        - An integer specifying the interrupt vector
#     priority      - An integer specifying the priority of the portThread. A value
#                     of 0 will result in a defalt value being assigned
#     noAutoConnect - Zero or missing indicates that portThread should automatically
#                     connect. Non-zero if explicit connect command must be issued.

gsIP488Configure("gpib1",1,1,0x69,0,0)

# GPIB addresses: 1=Tektronix scope, 2=Keithley 2000, 3=Fluke meter
# asynInterposeEosConfig(const char *portName, int addr,
#                        int processEosIn, int processEosOut);
asynInterposeEosConfig("gpib1", 1, 1, 0)
asynInterposeEosConfig("gpib1", 2, 1, 0)
asynInterposeEosConfig("gpib1", 3, 1, 0)

# asynOctetSetInputEos(const char *portName, int addr,
#                      const char *eosin,const char *drvInfo)
asynOctetSetInputEos("gpib1", 1, "\n")
asynOctetSetInputEos("gpib1", 2, "\n")
asynOctetSetInputEos("gpib1", 3, "\r")

# asynOctetConnect(const char *entry, const char *port, int addr,
#                  int timeout, int buffer_len, const char *drvInfo)
asynOctetConnect("gpib1:1", "gpib1", 1, 1, 80)
asynOctetConnect("gpib1:2", "gpib1", 2, 1, 80)
asynOctetConnect("gpib1:3", "gpib1", 3, 1, 80)

# Keithley 2000 DMM, connected with GPIB
dbLoadRecords("$(IP)/ipApp/Db/Keithley2kDMM_mf.db","P=xxx:,Dmm=D2,PORT=gpib1 2")

# send impromptu message to gpib device, parse reply
# (was GPIB_OI_block)
#dbLoadRecords("$(IP)/ipApp/Db/deviceCmdReply.db","P=xxx:,N=1,PORT=gpib1,ADDR=1,OMAX=100,IMAX=100")

# Second gpib module dedicated to devSkeletonGpib Link-10 devices
# gsIP488Configure(char *portName, int carrier, int module, int vector,
#                  unsigned int priority, int noAutoConnect)
#gsIP488Configure("L10",1,2,0x6A,0,0)
# Heidenhain AWE1024 at GPIB address $(A)
#dbLoadRecords("$(IP)/ipApp/Db/HeidAWE1024.db", "P=xxx:,L=10,A=6")

# Keithley 199 DMM at GPIB address $(A)
#dbLoadRecords("$(STD)/stdApp/Db/KeithleyDMM.db", "P=xxx:,L=10,A=26")


# END gpib.cmd ------------------------------------------------------------
