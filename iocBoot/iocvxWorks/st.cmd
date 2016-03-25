# vxWorks startup script

sysVmeMapShow

cd ""
< ../nfsCommands
< cdCommands

# How to set and get the clock rate (in Hz.  Default is 60 Hz)
#sysClkRateSet(100)
#sysClkRateGet()

################################################################################
cd topbin

# If the VxWorks kernel was built using the project facility, the following must
# be added before any C++ code is loaded (see SPR #28980).
sysCplusEnable=1

# If using a PowerPC CPU with more than 32MB of memory, and not building with longjump, then
# allocate enough memory here to force code to load in lower 32 MB.
##mem = malloc(1024*1024*96)

### Load synApps EPICS software
load("xxx.munch")
#ld(0,0,"xxx.munch")
cd startup

# Increase size of buffer for error logging from default 1256
errlogInit(20000)

# need more entries in wait/scan-record channel-access queue?
recDynLinkQsize = 1024

################################################################################
# Tell EPICS all about the record types, device-support modules, drivers,
# etc. in the software we just loaded (xxx.munch)
dbLoadDatabase("$(TOP)/dbd/iocxxxVX.dbd")
iocxxxVX_registerRecordDeviceDriver(pdbbase)

shellPromptSet "iocvxWorks> "
iocLogDisable=0

# devIocStats
dbLoadRecords("$(DEVIOCSTATS)/db/iocAdminVxWorks.db","IOC=xxx")

# Industry Pack support
< industryPack.cmd

# gpib support
#< gpib.cmd

# VME devices
< vme.cmd

# CAMAC hardware
#<camac.cmd

iocsh "common.iocsh"

###############################################################################
iocInit
###############################################################################

# If memory allocated at beginning free it now
##free(mem)

memShow

# write all the PV names to a local file
dbl > dbl-all.txt

# Diagnostic: CA links in all records
dbcar(0,1)

# print the time our boot was finished
date
