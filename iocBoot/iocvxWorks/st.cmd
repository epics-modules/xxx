# vxWorks startup script

sysVmeMapShow

# For devIocStats
#epicsEnvSet("ENGINEER", "engineer")
#epicsEnvSet("LOCATION", "location")
putenv("ENGINEER=engineer")
putenv("LOCATION=location")
putenv("GROUP=group")

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

# Specify largest array CA will transport
# Note for N sscanRecord data points, need (N+1)*8 bytes, else MEDM
# plot doesn't display
putenv "EPICS_CA_MAX_ARRAY_BYTES=64008"

# set the protocol path for streamDevice
epicsEnvSet("STREAM_PROTOCOL_PATH", ".")

################################################################################
# Tell EPICS all about the record types, device-support modules, drivers,
# etc. in the software we just loaded (xxx.munch)
dbLoadDatabase("$(TOP)/dbd/iocxxxVX.dbd")
iocxxxVX_registerRecordDeviceDriver(pdbbase)

### save_restore setup
< save_restore.cmd

### Access Security
dbLoadRecords("$(TOP)/xxxApp/Db/Security_Control.db","P=xxx:")
iocsh
asSetFilename("$(TOP)/iocBoot/accessSecurity.acf")
exit
asSetSubstitutions("P=xxx:")

### caputRecorder

# trap listener
dbLoadRecords("$(CAPUTRECORDER)/caputRecorderApp/Db/caputPoster.db","P=xxx:,N=300")
doAfterIocInit("registerCaputRecorderTrapListener('xxx:caputRecorderCommand')")

# GUI database
dbLoadRecords("$(CAPUTRECORDER)/caputRecorderApp/Db/caputRecorder.db","P=xxx:,N=300")

# second copy of GUI database
#dbLoadRecords("$(CAPUTRECORDER)/caputRecorderApp/Db/caputRecorder.db","P=xxxA:,N=300")

# Industry Pack support
< industryPack.cmd


# gpib support
#< gpib.cmd

# VME devices
< vme.cmd

# CAMAC hardware
#<camac.cmd

#< areaDetector.cmd

# Motors
#dbLoadTemplate("basic_motor.substitutions")
dbLoadTemplate("motor.substitutions")
#dbLoadTemplate("softMotor.substitutions")
#dbLoadTemplate("pseudoMotor.substitutions")

### Allstop, alldone
dbLoadRecords("$(MOTOR)/db/motorUtil.db", "P=xxx:")
doAfterIocInit("motorUtilInit('xxx:')")

### streamDevice example
#dbLoadRecords("$(TOP)/xxxApp/Db/streamExample.db","P=xxx:,PORT=serial1")

### Insertion-device control
#dbLoadRecords("$(STD)/stdApp/Db/IDctrl.db","P=xxx:,xx=02us")

### Scan-support software
# crate-resident scan.  This executes 1D, 2D, 3D, and 4D scans, and caches
# 1D data, but it doesn't store anything to disk.  (See 'saveData' below for that.)
putenv "SDB=$(SSCAN)/sscanApp/Db/standardScans.db"
dbLoadRecords("$(SDB)","P=xxx:,MAXPTS1=1000,MAXPTS2=1000,MAXPTS3=100,MAXPTS4=100,MAXPTSH=100")
#dbLoadRecords("$(SSCAN)/sscanApp/Db/scanAux.db","P=xxx:,S=scanAux,MAXPTS=100")

# Start the saveData task.  If you start this task, scan records mentioned
# in saveData.req will *always* write data files.  There is no programmable
# disable for this software.
dbLoadRecords("$(SSCAN)/sscanApp/Db/saveData.db","P=xxx:")
doAfterIocInit("saveData_Init('saveData.req', 'P=xxx:')")

dbLoadRecords("$(SSCAN)/sscanApp/Db/scanProgress.db","P=xxx:scanProgress:")
doAfterIocInit("seq &scanProgress, 'S=xxx:, P=xxx:scanProgress:'")

# configMenu example.  See create_manual_set() command after iocInit.
#dbLoadRecords("$(AUTOSAVE)/asApp/Db/configMenu.db","P=xxx:,CONFIG=scan1")
#doAfterIocInit("create_manual_set('scan1Menu.req','P=xxx:,CONFIG=scan1,CONFIGMENU=1')")

# A set of scan parameters for each positioner.  This is a convenience
# for the user.  It can contain an entry for each scannable thing in the
# crate.
dbLoadTemplate("scanParms.substitutions")

### Slits (If not supplied, RELTOCENTER defaults to zero)
dbLoadRecords("$(OPTICS)/opticsApp/Db/2slit.db","P=xxx:,SLIT=Slit1V,mXp=m3,mXn=m4,RELTOCENTER=0")
dbLoadRecords("$(OPTICS)/opticsApp/Db/2slit.db","P=xxx:,SLIT=Slit1H,mXp=m5,mXn=m6,RELTOCENTER=0")

### X-ray Instrumentation Associates Huber Slit Controller
# supported by a customized version of the SNL program written by Pete Jemian
# (Uses asyn record loaded separately)
#dbLoadRecords("$(OPTICS)/opticsApp/Db/xia_slit.db", "P=xxx:, HSC=hsc1:")
#dbLoadRecords("$(OPTICS)/opticsApp/Db/xia_slit.db", "P=xxx:, HSC=hsc2:")
#doAfterIocInit("seq  &xia_slit, 'name=hsc1, P=xxx:, HSC=hsc1:, S=xxx:asyn_6'")
#doAfterIocInit("seq  &xia_slit, 'name=hsc2, P=xxx:, HSC=hsc2:, S=xxx:asyn_6'")

### 2-post mirror
#dbLoadRecords("$(OPTICS)/opticsApp/Db/2postMirror.db","P=xxx:,Q=M1,mDn=m1,mUp=m2,LENGTH=0.3")

### User filters
#dbLoadRecords("$(OPTICS)/opticsApp/Db/filterMotor.db","P=xxx:,Q=fltr1:,MOTOR=m1,LOCK=fltr_1_2:")
#dbLoadRecords("$(OPTICS)/opticsApp/Db/filterMotor.db","P=xxx:,Q=fltr2:,MOTOR=m2,LOCK=fltr_1_2:")
#dbLoadRecords("$(OPTICS)/opticsApp/Db/filterLock.db","P=xxx:,Q=fltr2:,LOCK=fltr_1_2:,LOCK_PV=xxx:DAC1_1.VAL")

### Optical tables
putenv "DIR=$(OPTICS)/opticsApp/Db"
dbLoadRecords("$(DIR)/table.db","P=xxx:,Q=Table1,T=table1,M0X=m1,M0Y=m2,M1Y=m3,M2X=m4,M2Y=m5,M2Z=m6,GEOM=SRI")

### Io calculation
#dbLoadRecords("$(OPTICS)/opticsApp/Db/Io.db","P=xxx:Io:")
#doAfterIocInit("seq &Io, 'P=xxx:Io:,MONO=xxx:BraggEAO,VSC=xxx:scaler1'")

### Monochromator support ###

### Kohzu and PSL monochromators: Bragg and theta/Y/Z motors
# standard geometry (geometry 1)
dbLoadRecords("$(OPTICS)/opticsApp/Db/kohzuSeq.db","P=xxx:,M_THETA=m1,M_Y=m2,M_Z=m3,yOffLo=17.4999,yOffHi=17.5001")
doAfterIocInit("seq &kohzuCtl, 'P=xxx:, M_THETA=m1, M_Y=m2, M_Z=m3, GEOM=1, logfile=kohzuCtl.log'")

# modified geometry (geometry 2)
#dbLoadRecords("$(OPTICS)/opticsApp/Db/kohzuSeq.db","P=xxx:,M_THETA=m1,M_Y=m2,M_Z=m3,yOffLo=4,yOffHi=36")
#doAfterIocInit("seq &kohzuCtl, 'P=xxx:, M_THETA=m1, M_Y=m2, M_Z=m3, GEOM=2, logfile=kohzuCtl.log'")
# Example of specifying offset limits
#doAfterIocInit("epicsThreadSleep(5.)")
#doAfterIocInit("dbpf xxx:kohzu_yOffsetAO.DRVH 17.51")
#doAfterIocInit("dbpf xxx:kohzu_yOffsetAO.DRVL 17.49")

### Spherical grating monochromator
#dbLoadRecords("$(OPTICS)/opticsApp/Db/SGM.db","P=xxx:,N=1,M_x=m7,M_rIn=m6,M_rOut=m8,M_g=m9")

### 4-bounce high-resolution monochromator
#dbLoadRecords("$(OPTICS)/opticsApp/Db/hrSeq.db","P=xxx:,N=1,M_PHI1=m1,M_PHI2=m2")
#doAfterIocInit("dbpf 'xxx:HR1CtlDebug','1'")
#doAfterIocInit("seq &hrCtl, 'P=xxx:, N=1, M_PHI1=m4, M_PHI2=m5, logfile=hrCtl.log'")
#dbLoadRecords("$(OPTICS)/opticsApp/Db/hrSeq.db","P=xxx:,N=2,M_PHI1=m11,M_PHI2=m12")

### multilayer monochromator: Bragg and theta/Y/Z motors
#dbLoadRecords("$(OPTICS)/opticsApp/Db/ml_monoSeq.db","P=xxx:")
#doAfterIocInit("seq &ml_monoCtl, 'P=xxx:, M_THETA=m1, M_THETA2=m2, M_Y=m3, M_Z=m4, Y_OFF=35., GEOM=1'")

### Orientation matrix, four-circle diffractometer (see seq program 'orient' below)
#dbLoadRecords("$(OPTICS)/opticsApp/Db/orient.db", "P=xxx:,O=1,PREC=6")
#dbLoadTemplate("orient_xtals.substitutions")
#doAfterIocInit("seq &orient, 'P=xxx:orient1:,PM=xxx:,mTTH=m13,mTH=m14,mCHI=m15,mPHI=m16'")

# Coarse/Fine stage
dbLoadRecords("$(OPTICS)/opticsApp/Db/CoarseFineMotor.db","P=xxx:cf1:,PM=xxx:,CM=m7,FM=m8")

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

# user-assignable ramp/tweak
dbLoadRecords("$(STD)/stdApp/Db/ramp_tweak.db","P=xxx:,Q=rt1")

# pvHistory (in-crate archive of up to three PV's)
dbLoadRecords("$(STD)/stdApp/Db/pvHistory.db","P=xxx:,N=1,MAXSAMPLES=1440")

# software timer
dbLoadRecords("$(STD)/stdApp/Db/timer.db","P=xxx:,N=1")

# Slow feedback
dbLoadTemplate "pid_slow.substitutions"
dbLoadTemplate "async_pid_slow.substitutions"

# Miscellaneous PV's, such as burtResult
dbLoadRecords("$(STD)/stdApp/Db/misc.db","P=xxx:")

# devIocStats
dbLoadRecords("$(DEVIOCSTATS)/db/iocAdminVxWorks.db","IOC=xxx")

### Queensgate piezo driver
#dbLoadRecords("$(IP)/ipApp/Db/pzt_3id.db","P=xxx:")
#dbLoadRecords("$(IP)/ipApp/Db/pzt.db","P=xxx:,PORT=")

### Queensgate Nano2k piezo controller
#dbLoadRecords("$(STD)/stdApp/Db/Nano2k.db","P=xxx:,S=s1")

### Load database records for Femto amplifiers
#dbLoadRecords("$(STD)/stdApp/Db/femto.db","P=xxx:,H=fem01:,F=seq01:")
putenv "FBO=xxx:Unidig1Bo"
#doAfterIocInit("seq &femto,'name=fem1,P=xxx:,H=fem01:,F=seq01:,G1=$(FBO)6,G2=$(FBO)7,G3=$(FBO)8,NO=$(FBO)10'")

### Load database records for dual PF4 filters
#dbLoadRecords("$(OPTICS)/opticsApp/Db/pf4common.db","P=xxx:,H=pf4:,A=A,B=B")
#dbLoadRecords("$(OPTICS)/opticsApp/Db/pf4bank.db","P=xxx:,H=pf4:,B=A")
#dbLoadRecords("$(OPTICS)/opticsApp/Db/pf4bank.db","P=xxx:,H=pf4:,B=B")
# Start PF4 filter sequence programs
#        name = what user will call it
#        P    = prefix of database and sequencer
#        H    = hardware (i.e. pf4)
#        B    = bank indicator (i.e. A,B)
#        M    = Monochromatic-beam energy PV
#        BP   = Filter control bit PV prefix
#        B1   = Filter control bit 0 number
#        B2   = Filter control bit 1 number
#        B3   = Filter control bit 2 number
#        B4   = Filter control bit 3 number
#doAfterIocInit("seq &pf4,'name=pf1,P=xxx:,H=pf4:,B=A,M=xxx:BraggEAO,BP=xxx:Unidig1Bo,B1=3,B2=4,B3=5,B4=6'")
#doAfterIocInit("seq &pf4,'name=pf2,P=xxx:,H=pf4:,B=B,M=xxx:BraggEAO,BP=xxx:Unidig1Bo,B1=7,B2=8,B3=9,B4=10'")

### Load database records for alternative PF4-filter support
dbLoadTemplate "filter.substitutions"
#doAfterIocInit("seq &filterDrive,'NAME=filterDrive,P=xxx:,R=filter:,NUM_FILTERS=16'")

# trajectory scan
#dbLoadRecords("$(MOTOR)/motorApp/Db/trajectoryScan.db","P=xxx:,R=traj1:,NAXES=2,NELM=300,NPULSE=300")
#doAfterIocInit("seq &MAX_trajectoryScan, 'P=xxx:,R=traj1:,M1=m1,M2=m2,M3=m3,M4=m4,M5=m5,M6=m6,M7=m7,M8=m8,PORT=none'")

### Load database record for alive heartbeating support.
# RHOST specifies the IP address that receives the heartbeats.
dbLoadRecords("$(ALIVE)/aliveApp/Db/alive.db", "P=xxx:,RHOST=164.54.100.11")

###############################################################################
# Set shell prompt
shellPromptSet "iocvxWorks> "
iocLogDisable=0
iocInit
###############################################################################

# write all the PV names to a local file
dbl > dbl-all.txt
memShow

# If memory allocated at beginning free it now
##free(mem)

# Diagnostic: CA links in all records
#dbcar(0,1)


# print the time our boot was finished
date
