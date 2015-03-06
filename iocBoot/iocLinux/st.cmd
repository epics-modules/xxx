# Linux startup script

# For devIocStats
epicsEnvSet("ENGINEER","engineer")
epicsEnvSet("LOCATION","location")
epicsEnvSet("GROUP","group")

< envPaths

# save_restore.cmd needs the full path to the startup directory, which
# envPaths currently does not provide
epicsEnvSet(STARTUP,$(TOP)/iocBoot/$(IOC))

# Increase size of buffer for error logging from default 1256
errlogInit(20000)

# Specify largest array CA will transport
# Note for N doubles, need N*8 bytes+some overhead
epicsEnvSet EPICS_CA_MAX_ARRAY_BYTES 64010

################################################################################
# Tell EPICS all about the record types, device-support modules, drivers,
# etc. in the software we just loaded (xxx.munch)
dbLoadDatabase("../../dbd/iocxxxLinux.dbd")
iocxxxLinux_registerRecordDeviceDriver(pdbbase)

### save_restore setup
< save_restore.cmd

# Access Security
dbLoadRecords("$(TOP)/xxxApp/Db/Security_Control.db","P=xxx:")
asSetFilename("$(TOP)/iocBoot/accessSecurity.acf")
asSetSubstitutions("P=xxx:")

### caputRecorder

# trap listener
dbLoadRecords("$(CAPUTRECORDER)/caputRecorderApp/Db/caputPoster.db","P=xxx:,N=300")
doAfterIocInit("registerCaputRecorderTrapListener('xxx:caputRecorderCommand')")

# GUI database
dbLoadRecords("$(CAPUTRECORDER)/caputRecorderApp/Db/caputRecorder.db","P=xxx:,N=300")

# second copy of GUI database
#dbLoadRecords("$(CAPUTRECORDER)/caputRecorderApp/Db/caputRecorder.db","P=xxxA:,N=300")

# if you have hdf5 and szip, you can use this
#< areaDetector.cmd

# soft scaler for testing
< softScaler.cmd

# user-assignable ramp/tweak
dbLoadRecords("$(STD)/stdApp/Db/ramp_tweak.db","P=xxx:,Q=rt1")

# serial support
#< serial.cmd

# Motors
#dbLoadTemplate("basic_motor.substitutions")
#dbLoadTemplate("motor.substitutions")
dbLoadTemplate("softMotor.substitutions")
dbLoadTemplate("pseudoMotor.substitutions")
< motorSim.cmd
# motorUtil (allstop & alldone)
dbLoadRecords("$(MOTOR)/db/motorUtil.db", "P=xxx:")
# Run this after iocInit:
doAfterIocInit("motorUtilInit('xxx:')")

### Scan-support software
# crate-resident scan.  This executes 1D, 2D, 3D, and 4D scans, and caches
# 1D data, but it doesn't store anything to disk.  (See 'saveData' below for that.)
dbLoadRecords("$(SSCAN)/sscanApp/Db/standardScans.db","P=xxx:,MAXPTS1=1000,MAXPTS2=1000,MAXPTS3=1000,MAXPTS4=1000,MAXPTSH=1000")
dbLoadRecords("$(SSCAN)/sscanApp/Db/saveData.db","P=xxx:")
# Run this after iocInit:
doAfterIocInit("saveData_Init(saveData.req, 'P=xxx:')")
dbLoadRecords("$(SSCAN)/sscanApp/Db/scanProgress.db","P=xxx:scanProgress:")
# Run this after iocInit:
doAfterIocInit("seq &scanProgress, 'S=xxx:, P=xxx:scanProgress:'")

# configMenu example.
dbLoadRecords("$(AUTOSAVE)/asApp/Db/configMenu.db","P=xxx:,CONFIG=scan1")
# Note that the request file MUST be named $(CONFIG)Menu.req
# If the macro CONFIGMENU is defined with any value, backup (".savB") and
# sequence files (".savN") will not be written.  We don't want these for configMenu.
# Run this after iocInit:
doAfterIocInit("create_manual_set('scan1Menu.req','P=xxx:,CONFIG=scan1,CONFIGMENU=1')")
# You could make scan configurations read-only:
#dbLoadRecords("$(AUTOSAVE)/asApp/Db/configMenu.db","P=xxx:,CONFIG=scan1,ENABLE_SAVE=0")

# read-only configMenu example.  (Read-only, because we're not calling create_manual_set().)
#dbLoadRecords("$(AUTOSAVE)/asApp/Db/configMenu.db","P=xxx:,CONFIG=scan2")

# A set of scan parameters for each positioner.  This is a convenience
# for the user.  It can contain an entry for each scannable thing in the
# crate.
dbLoadTemplate("scanParms.substitutions")

### Slits
dbLoadRecords("$(OPTICS)/opticsApp/Db/2slit.db","P=xxx:,SLIT=Slit1V,mXp=m3,mXn=m4")
dbLoadRecords("$(OPTICS)/opticsApp/Db/2slit.db","P=xxx:,SLIT=Slit1H,mXp=m5,mXn=m6")

# X-ray Instrumentation Associates Huber Slit Controller
# supported by a customized version of the SNL program written by Pete Jemian
#dbLoadRecords("$(OPTICS)/opticsApp/Db/xia_slit.db", "P=xxx:, HSC=hsc1:")
#dbLoadRecords("$(OPTICS)/opticsApp/Db/xia_slit.db", "P=xxx:, HSC=hsc2:")
#dbLoadRecords("$(IP)/ipApp/Db/generic_serial.db", "P=xxx:,C=0,SERVER=serial7")
# Run this after iocInit:
#doAfterIocInit("seq  &xia_slit, 'name=hsc1, P=xxx:, HSC=hsc1:, S=xxx:seriala[6]'")

### 2-post mirror
#dbLoadRecords("$(OPTICS)/opticsApp/Db/2postMirror.db","P=xxx:,Q=M1,mDn=m1,mUp=m2,LENGTH=0.3")

### User filters
#dbLoadRecords("$(OPTICS)/opticsApp/Db/filterMotor.db","P=xxx:,Q=fltr1:,MOTOR=m1,LOCK=fltr_1_2:")
#dbLoadRecords("$(OPTICS)/opticsApp/Db/filterMotor.db","P=xxx:,Q=fltr2:,MOTOR=m2,LOCK=fltr_1_2:")
#dbLoadRecords("$(OPTICS)/opticsApp/Db/filterLock.db","P=xxx:,Q=fltr2:,LOCK=fltr_1_2:,LOCK_PV=xxx:DAC1_1.VAL")

### Optical tables
#dbLoadRecords("$(OPTICS)/opticsApp/Db/table.db","P=xxx:,Q=Table1,T=table1,M0X=m1,M0Y=m2,M1Y=m3,M2X=m4,M2Y=m5,M2Z=m6,GEOM=SRI")
dbLoadRecords("$(OPTICS)/opticsApp/Db/table.db","P=xxx:,Q=Table1,T=table1,M0X=m1,M0Y=m2,M1Y=m3,M2X=m4,M2Y=m5,M2Z=m6,GEOM=NEWPORT")
#dbLoadRecords("$(OPTICS)/opticsApp/Db/table.db","P=xxx:,Q=Table2,T=table2,M0X=m1,M0Y=m2,M1Y=m3,M2X=m4,M2Y=m5,M2Z=m6,GEOM=SRI")

# Io calculation
dbLoadRecords("$(OPTICS)/opticsApp/Db/Io.db","P=xxx:Io:")

### Monochromator support ###
# Kohzu and PSL monochromators: Bragg and theta/Y/Z motors
# standard geometry (geometry 1)
#dbLoadRecords("$(OPTICS)/opticsApp/Db/kohzuSeq.db","P=xxx:,M_THETA=m1,M_Y=m2,M_Z=m3,yOffLo=17.4999,yOffHi=17.5001")
# Run this after iocInit:
#doAfterIocInit("seq &kohzuCtl, 'P=xxx:, M_THETA=m1, M_Y=m2, M_Z=m3, GEOM=1, logfile=kohzuCtl.log'")
# modified geometry (geometry 2)
#dbLoadRecords("$(OPTICS)/opticsApp/Db/kohzuSeq.db","P=xxx:,M_THETA=m1,M_Y=m2,M_Z=m2,yOffLo=4,yOffHi=36")
# Run this after iocInit:
#doAfterIocInit("seq &kohzuCtl, 'P=xxx:, M_THETA=m1, M_Y=m2, M_Z=m3, GEOM=2, logfile=kohzuCtl.log'")

# Spherical grating monochromator
#dbLoadRecords("$(OPTICS)/opticsApp/Db/SGM.db","P=xxx:,N=1,M_x=m7,M_rIn=m6,M_rOut=m8,M_g=m9")

# 4-bounce high-resolution monochromator
dbLoadRecords("$(OPTICS)/opticsApp/Db/hrSeq.db","P=xxx:,N=1,M_PHI1=m4,M_PHI2=m5")
# Run this after iocInit:
doAfterIocInit("seq &hrCtl, 'P=xxx:, N=1, M_PHI1=m4, M_PHI2=m5, logfile=hrCtl.log'")

### Orientation matrix, four-circle diffractometer (see seq program 'orient' below)
#dbLoadRecords("$(OPTICS)/opticsApp/Db/orient.db", "P=xxx:,O=1,PREC=4")
#dbLoadTemplate("orient_xtals.substitutions")
# Run this after iocInit:
#doAfterIocInit("seq &orient, 'P=xxx:orient1:,PM=xxx:,mTTH=m9,mTH=m10,mCHI=m11,mPHI=m12'")

# Load single element Canberra AIM MCA and ICB modules
#< canberra_1.cmd

# Load 13 element detector software
#< canberra_13.cmd

# Load 3 element detector software
#< canberra_3.cmd

### Stuff for user programming ###
< calc.cmd

# 4-step measurement
dbLoadRecords("$(STD)/stdApp/Db/4step.db", "P=xxx:,Q=4step:")

# Slow feedback
dbLoadTemplate "pid_slow.substitutions"
dbLoadTemplate "async_pid_slow.substitutions"
#dbLoadTemplate "fb_epid.substitutions"

# Miscellaneous PV's, such as burtResult
dbLoadRecords("$(STD)/stdApp/Db/misc.db","P=xxx:")

# devIocStats
dbLoadRecords("$(DEVIOCSTATS)/db/iocAdminSoft.db","IOC=xxx")

### Queensgate piezo driver
#dbLoadRecords("$(IP)/ipApp/Db/pzt.db","P=xxx:")

### Queensgate Nano2k piezo controller
#dbLoadRecords("$(STD)/stdApp/Db/Nano2k.db","P=xxx:,S=s1")

### Load database records for Femto amplifiers
#dbLoadRecords("$(STD)/stdApp/Db/femto.db","P=xxx:,H=fem01:,F=seq01:")
# Run this after iocInit:
#doAfterIocInit("seq femto,'name=fem1,P=xxx:,H=fem01:,F=seq01:,G1=xxx:Unidig1Bo6,G2=xxx:Unidig1Bo7,G3=xxx:Unidig1Bo8,NO=xxx:Unidig1Bo10'")

### Load database records for dual PF4 filters
#dbLoadRecords("$(OPTICS)/opticsApp/Db/pf4common.db","P=xxx:,H=pf4:,A=A,B=B")
#dbLoadRecords("$(OPTICS)/opticsApp/Db/pf4bank.db","P=xxx:,H=pf4:,B=A")
#dbLoadRecords("$(OPTICS)/opticsApp/Db/pf4bank.db","P=xxx:,H=pf4:,B=B")
# Run this after iocInit:
#doAfterIocInit("seq pf4,'name=pf1,P=xxx:,H=pf4:,B=A,M=xxx:userTran10.I,B1=xxx:userTran10.A,B2=xxx:userTran10.B,B3=xxx:userTran10.C,B4=xxx:userTran10.D'")
#doAfterIocInit("seq pf4,'name=pf2,P=xxx:,H=pf4:,B=B,M=xxx:userTran10.I,B1=xxx:userTran10.E,B2=xxx:userTran10.F,B3=xxx:userTran10.G,B4=xxx:userTran10.H'")

### Load database records for alternative PF4-filter support
#dbLoadTemplate "filter.substitutions"
# Run this after iocInit:
#doAfterIocInit("seq filterDrive,'NAME=filterDrive,P=xxx:,R=filter:,NUM_FILTERS=16'")

### Load database record for alive heartbeating support.
# RHOST specifies the IP address that receives the heartbeats.
#dbLoadRecords("$(ALIVE)/aliveApp/Db/alive.db", "P=xxx:,RHOST=X.X.X.X")

###############################################################################
iocInit
###############################################################################

# write all the PV names to a local file
dbl > dbl-all.txt

# Report  states of database CA links
dbcar(*,1)

# print the time our boot was finished
date

