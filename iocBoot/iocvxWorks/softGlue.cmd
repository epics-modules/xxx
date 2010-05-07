# BEGIN softGlue.cmd ----------------------------------------------------------
# This must run after industryPack.cmd
#
# Write content to the FPGA
# initIP_EP200_FPGA(ushort_t carrier, ushort_t slot, char *filename)
initIP_EP200_FPGA(0, 2, "$(SOFTGLUE)/db/EP200_FPGA.hex")

# Each instance of a fieldIO_registerSet component is initialized as follows:
#
#int initIp1k125(const char *portName, ushort_t carrier, ushort_t slot,
#	int msecPoll, int dataDir, int sopcOffset, int sopcVector,
#	int risingMask, int fallingMask)
# For example:
#initIp1k125("test1",0,2,0,0x0,  0x0 ,0x80,0,0)
# These commands implement field I/O
initIp1k125("sg_in1",0,2,0,0x0,  0x0 ,0x80,0,0)
initIp1k125("sg_out1",0,2,0,0x101, 0x10 ,0x81,0,0)


# All instances of a single-register component are initialized with a single
# call, as follows:
#
#initIp1k125SingleRegisterPort(const char *portName, ushort_t carrier,
#	ushort_t slot)
#
# For example:
# initIp1k125SingleRegisterPort("SOFTGLUE", 0, 2)
	
initIp1k125SingleRegisterPort("SOFTGLUE", 0, 2)


# Load a single database that all database fragments supporting single-register
# components can use to show which signals are connected together.  This
# database is not needed for the functioning of the components, it's purely
# for the user interface.
dbLoadRecords("$(SOFTGLUE)/db/softGlue_SignalShow.db","P=xxx:,H=softGlue:")

# Load a set of database fragments for each single-register component.
dbLoadRecords("$(SOFTGLUE)/db/softGlue_FPGAContent.db", "P=xxx:,H=softGlue:,PORT=SOFTGLUE")
# END softGlue.cmd ------------------------------------------------------------
