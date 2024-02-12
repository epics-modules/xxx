# Use the following line if motorAcsMotion is built as a submodule of motor
iocshLoad("$(MOTOR)/iocsh/ACS_Motion_AuxIO_tcp.iocsh", "INSTANCE=ACS1_IO,IP_ADDR=10.0.0.100,NUM_CHAN=32,POLL_PERIOD=0.1")

# Load auxilliary I/O
dbLoadTemplate("substitutions/AcsMotionAuxIO.substitutions","P=$(PREFIX)")

# Load an asyn record for debugging
dbLoadRecords("$(ASYN)/db/asynRecord.db","P=$(PREFIX),R=io:asyn,PORT=ACS1_IO_ETH,ADDR=0,OMAX=256,IMAX=256")
