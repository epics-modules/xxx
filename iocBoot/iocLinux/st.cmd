# Linux startup script

< envPaths

# Increase size of buffer for error logging from default 1256
errlogInit(20000)

################################################################################
# Tell EPICS all about the record types, device-support modules, drivers,
# etc. in the software we just loaded (xxx.munch)
dbLoadDatabase("../../dbd/iocxxxLinux.dbd")
iocxxxLinux_registerRecordDeviceDriver(pdbbase)

< common.iocsh

# soft scaler for testing
< softScaler.cmd

< motorSim.cmd

# devIocStats
dbLoadRecords("$(DEVIOCSTATS)/db/iocAdminSoft.db","IOC=xxx")

###############################################################################
iocInit
###############################################################################

# write all the PV names to a local file
dbl > dbl-all.txt

# Diagnostic: CA links in all records
dbcar(0,1)

# print the time our boot was finished
date
