# vxWorks startup script

# Read environment variables
< envPaths

################################################################################
# Tell EPICS all about the record types, device-support modules, drivers,
# etc. in the software we just loaded (xxx.munch)
dbLoadDatabase("../../dbd/iocxxx.dbd")
iocxxx_registerRecordDeviceDriver(pdbbase)

# Increase size of buffer for error logging from default 1256
errlogInit(5000)

# debug sseq record
#var sseqRecDebug,10

# Note that you need an MPF router not only for IP modules, but also for
# the AIM MCA support and other MPF servers
routerInit
localMessageRouterStart(0)

# Set up 2 local serial ports
initTtyPort("serial1", "/dev/ttyS0", 38400, "N",  1, 8, "N", 1000) # For MM4000
initTtyPort("serial2", "/dev/ttyS1", 19200, "N",  1, 8, "N", 1000) # For Keithley 2000
initSerialServer("serial1", "serial1", 1000, 20, "")
initSerialServer("serial2", "serial2", 1000, 20, "")
# Set up 4 serial ports on remote Moxa terminal server
#initInetPort("serial3","164.54.160.50",4001,1000) 
#initInetPort("serial4","164.54.160.50",4002,1000) 
#initInetPort("serial5","164.54.160.50",4003,1000) 
#initInetPort("serial6","164.54.160.50",4004,1000) 
#initSerialServer("serial3","serial3",1000,20,"") 
#initSerialServer("serial4","serial4",1000,20,"") 
#initSerialServer("serial5","serial5",1000,20,"") 
#initSerialServer("serial6","serial6",1000,20,"") 
 
< save_restore.cmd

# need more entries in wait/scan-record channel-access queue?
#var recDynLinkQsize, 1024

# Specify largest array CA will transport
# Note for N sscanRecord data points, need (N+1)*8 bytes, else MEDM
# plot doesn't display
epicsEnvSet EPICS_CA_MAX_ARRAY_BYTES 64008

### save_restore
#dbLoadRecords("$(AUTOSAVE)asApp/Db/SR_array_test.vdb", "P=xxx:,N=10")
dbLoadRecords("$(AUTOSAVE)asApp/Db/save_restoreStatus.db", "P=xxx:")

# Love Controllers
#var devLoveDebug,1
#var loveServerDebug,1
#dbLoadRecords("$(IP)/ipApp/Db/love.db", "P=xxx:,Q=Love_0,C=0,PORT=PORT2,ADDR=1");

# interpolation
dbLoadRecords("$(CALC)/calcApp/Db/interp.db", "P=xxx:")


# X-ray Instrumentation Associates Huber Slit Controller
# supported by a customized version of the SNL program written by Pete Jemian
#dbLoadRecords("$(OPTICS)/opticsApp/Db/xia_slit.db", "P=xxx:, HSC=hsc1:")
#dbLoadRecords("$(OPTICS)/opticsApp/Db/xia_slit.db", "P=xxx:, HSC=hsc2:")
#dbLoadRecords("$(IP)/ipApp/Db/generic_serial.db", "P=xxx:,C=0,SERVER=serial7")

##### Pico Motors (Ernest Williams MHATT-CAT)
##### Motors (see picMot.substitutions in same directory as this file) ####
#dbLoadTemplate("picMot.substitutions")


##############################################################################

# Insertion-device control
dbLoadRecords("$(STD)/stdApp/Db/IDctrl.db","P=xxx:,xx=02us")


###############################################################################

##### Motors (see motors.substitutions in same directory as this file) ####
dbLoadTemplate("motor.substitutions")

# Newport MM4000 driver setup parameters: 
#     (1) max. controllers, (2)Unused, (3)polling rate (min=1Hz,max=60Hz) 
MM4000Setup(3, 0, 10)

# Newport MM4000 driver configuration parameters: 
#     (1)controller# being configured,
#     (2)port type: 0-GPIB_PORT or 1-RS232_PORT,
#     (3)GPIB link or MPF server location
#     (4) GPIB address (int) or mpf serial server name (string)
MM4000Config(0, 1, 0, "serial1")

# Newport PM500 driver setup parameters:
#     (1) maximum number of controllers in system
#     (2) maximum number of channels on any controller
#     (3) motor task polling rate (min=1Hz,max=60Hz)
#PM500Setup(1, 3, 10)

# Newport PM500 configuration parameters:
#     (1) card being configured
#     (2) port type (0-GPIB_PORT, 1-RS232_PORT)
#     (3) GPIB link or MPF server location
#     (4) GPIB address (int) or mpf serial server name (string)
#PM500Config(0, 1, 0, "serial3")

# McClennan PM304 driver setup parameters:
#     (1) maximum number of controllers in system
#     (2) maximum number of channels on any controller
#     (3) motor task polling rate (min=1Hz, max=60Hz)
#PM304Setup(1, 1, 10)

# McClennan PM304 driver configuration parameters:
#     (1) controller being configured
#     (2) MPF server location
#     (3) MPF serial server name (string)
#PM304Config(0, 0, "serial4")

# ACS MCB-4B driver setup parameters:
#     (1) maximum number of controllers in system
#     (2) maximum number of axes per controller
#     (3) motor task polling rate (min=1Hz, max=60Hz)
#MCB4BSetup(1, 4, 10)

# ACS MCB-4B driver configuration parameters:
#     (1) controller being configured
#     (2) MPF server location
#     (3) MPF server name (string)
#MCB4BConfig(0, 0, "serial2")

# A set of scan parameters for each positioner.  This is a convenience
# for the user.  It can contain an entry for each scannable thing in the
# crate.
dbLoadTemplate("scanParms.substitutions")

###############################################################################

### Allstop, alldone
# This database must agree with the motors and other positioners you've actually loaded.
# Several versions (e.g., all_com_32.db) are in stdApp/Db
dbLoadRecords("$(STD)/stdApp/Db/all_com_8.db","P=xxx:")

### Scan-support software
# crate-resident scan.  This executes 1D, 2D, 3D, and 4D scans, and caches
# 1D data, but it doesn't store anything to disk.  (See 'saveData' below for that.)
dbLoadRecords("$(SSCAN)/sscanApp/Db/scan.db","P=xxx:,MAXPTS1=4000,MAXPTS2=200,MAXPTS3=10,MAXPTS4=10,MAXPTSH=4000")

# Slits
dbLoadRecords("$(OPTICS)/opticsApp/Db/2slit.db","P=xxx:,SLIT=Slit1V,mXp=m3,mXn=m4")
dbLoadRecords("$(OPTICS)/opticsApp/Db/2slit.db","P=xxx:,SLIT=Slit1H,mXp=m5,mXn=m6")

# 2-post mirror
#dbLoadRecords("$(OPTICS)/opticsApp/Db/2postMirror.db","P=xxx:,Q=M1,mDn=m1,mUp=m2,LENGTH=0.3")

# User filters
#dbLoadRecords("$(OPTICS)/opticsApp/Db/filterMotor.db","P=xxx:,Q=fltr1:,MOTOR=m1,LOCK=fltr_1_2:")
#dbLoadRecords("$(OPTICS)/opticsApp/Db/filterMotor.db","P=xxx:,Q=fltr2:,MOTOR=m2,LOCK=fltr_1_2:")

# Optical tables
#var tableRecordDebug,1
dbLoadRecords("$(OPTICS)/opticsApp/Db/table.db","P=xxx:,Q=Table1,T=table1,M0X=m1,M0Y=m2,M1Y=m3,M2X=m4,M2Y=m5,M2Z=m6,GEOM=SRI")

### Monochromator support ###
# Kohzu and PSL monochromators: Bragg and theta/Y/Z motors
# standard geometry (geometry 1)
dbLoadRecords("$(OPTICS)/opticsApp/Db/kohzuSeq.db","P=xxx:,M_THETA=m1,M_Y=m2,M_Z=m3,yOffLo=17.4999,yOffHi=17.5001")
# modified geometry (geometry 2)
dbLoadRecords("$(OPTICS)/opticsApp/Db/kohzuSeq.db","P=xxx:,M_THETA=m1,M_Y=m2,M_Z=m3,yOffLo=4,yOffHi=36")

# Heidenhain ND261 encoder (for PSL monochromator)
#dbLoadRecords("$(IP)/ipApp/Db/heidND261.db", "P=xxx:,C=0,SERVER=serial1")

# Spherical grating monochromator
dbLoadRecords("$(OPTICS)/opticsApp/Db/SGM.db","P=xxx:,N=1,M_x=m1,M_rIn=m2,M_rOut=m3,M_g=m4")

# 4-bounce high-resolution monochromator
dbLoadRecords("$(OPTICS)/opticsApp/Db/hrSeq.db","P=xxx:,N=1,M_PHI1=m1,M_PHI2=m2")
#dbLoadRecords("$(OPTICS)/opticsApp/Db/hrSeq.db","P=xxx:,N=2,M_PHI1=m1,M_PHI2=m2")

### Canberra AIM Multichannel Analyzer ###
#var mcaRecordDebug,1
#var devMcaMpfDebug,1
#var mcaAIMServerDebug,1
#var aimDebug,1
#var icbDebug,1
#var icbServerDebug,1
#var icbDspDebug,1
#var icbTcaDebug,1

# AIMConfig(char *serverName, int etherAddr, int port, int maxChans, 
#	int maxSignals, int maxSequences, char *etherDev, int queueSize)
#
# serverName:   defined here, must agree with dbLoadRecords command
# etherAddr:    ethernet address of AIM module
# port:         Which ADC port of the AIM module does this config involve? [1,2]
# maxChans:     Histogram bins per signal per sequence.  (If a multiplexor or
#               MCS module is in use, this must agree with hardware setting.)
# maxSignals:   How many signals (multiplexed ADC inputs)?  (If a multiplexor
#               or MCS module is in use, this must agree with hardware setting.)
# maxSequences: How many sequences (usually, a sequence is a "time slice")?
# etherDev:     vxWorks device used to communicate over the network to AIM.
#               Typically "eth0" or "eth1"
# queueSize:    size of MPF message queue for this server (100 should be plenty)
#
# EXAMPLE:
#   AIMConfig("AIM1/2", 0x59E, 2, 2048, 1, 1, "dc0", 100)

AIMConfig("AIM1/2", 0x59E, 2, 4000, 1, 1, "eth0", 100)

dbLoadRecords("$(MCA)/mcaApp/Db/mca.db","P=xxx:,M=mca1,INP=#C0 S0 @AIM1/2,DTYPE=MPF MCA,NCHAN=4000")

# Initialize ICB software, and create a new ICB server
# icbSetup(const char *serverName, int maxModules, int queueSize)
#
# serverName:   defined here, must agree with icbConfig and dbLoadRecords commands
# maxModules:   Maximum number of ICB modules that this server will control
# queueSize:    size of MPF message queue for this server (100 should be plenty)
icbSetup("icb/1", 10, 100)

# Configure an ICB module on this server
# icbConfig(const char *serverName, int module, int etherAddr, int icbAddress)
#
# serverName:   defined in icbSetup above
# module:       the index number for this module (0,1,2...)
# etherAddr:    ethernet address of AIM module
# icbAddress:   ICB address of this module (set with internal rotary switch, 0x0-0xF)
icbConfig("icb/1", 0, 0x59E, 5)

# In dbLoadRecords commands for ICB devices
#    CARD   = (0,1) for (local/remote),
#    SERVER = server name supplied as argument to icbConfig(),
#    ADDR   = module number supplied as argument to icbConfig()

dbLoadRecords("$(MCA)/mcaApp/Db/icb_adc.db","P=xxx:,ADC=icbAdc1,CARD=0,SERVER=icb/1,ADDR=0")

icbConfig("icb/1", 1, 0x59E, 2)
dbLoadRecords("$(MCA)/mcaApp/Db/icb_hvps.db","P=xxx:,HVPS=icbHvps1,CARD=0,SERVER=icb/1,ADDR=1,LIMIT=1000")

icbConfig("icb/1", 2, 0x59E, 3)
dbLoadRecords("$(MCA)/mcaApp/Db/icb_amp.db","P=xxx:,AMP=icbAmp1,CARD=0,SERVER=icb/1,ADDR=2")

# icbTcaSetup(char *serverName, int maxModules, int queueSize)
#
# serverName:   defined here, must agree with icbTcaConfig and dbLoadRecords commands
# maxModules:   Maximum number of TCA modules that this server will control
# queueSize:    size of MPF message queue for this server (100 should be plenty)

icbTcaSetup("icbTca/1", 3, 100)

# icbTcaConfig(char *serverName, int module, int etherAddr, int icbAddress)
#
# serverName:   defined in icbTcaSetup above
# module:       the index number for this module (0,1,2...)
# etherAddr:    ethernet address of AIM module
# icbAddress:   ICB address of this module (set with internal rotary switch, 0x0-0xF)

icbTcaConfig("icbTca/1", 0, 0x59E, 8)
dbLoadRecords("$(MCA)/mcaApp/Db/icb_tca.db","P=xxx:,TCA=icbTca1,MCA=mca1,CARD=0,SERVER=icbTca/1,ADDR=0")

# icbDspSetup(char *serverName, int maxModules, int queueSize)
#
# serverName:   defined here, must agree with icbDspConfig and dbLoadRecords commands
# maxModules:   Maximum number of DSP 9660 modules that this server will control
# queueSize:    size of MPF message queue for this server (100 should be plenty)

icbDspSetup("icbDsp/1", 3, 100)

# icbDspConfig(char *serverName, int module, int etherAddr, int icbAddress)
#
# serverName:   defined in icbDspSetup above
# module:       the index number for this module (0,1,2...)
# etherAddr:    ethernet address of AIM module
# icbAddress:   ICB address of this module (set with internal rotary switch, 0x0-0xF)

icbDspConfig("icbDsp/1", 0, 0x59E, 6)
dbLoadRecords("$(MCA)/mcaApp/Db/icbDsp.db", "P=xxx:,DSP=dsp1,CARD=0,SERVER=icbDsp/1,ADDR=0")

# Load 13 element detector software
#< 13element.cmd

# Load 3 element detector software
#< 3element.cmd

### Stuff for user programming ###
dbLoadRecords("$(CALC)/calcApp/Db/userCalcs10.db","P=xxx:")
dbLoadRecords("$(CALC)/calcApp/Db/userStringCalcs10.db","P=xxx:")
dbLoadRecords("$(CALC)/calcApp/Db/userTransforms10.db","P=xxx:")
# extra userCalcs (must also load userCalcs10.db for the enable switch)
dbLoadRecords("$(CALC)/calcApp/Db/userCalcN.db","P=xxx:,N=I_Detector")
#dbLoadRecords("$(CALC)/calcApp/Db/userAve10.db","P=xxx:")
# string sequence (sseq) record
dbLoadRecords("$(STD)/stdApp/Db/yySseq.db","P=xxx:,S=Sseq1")
dbLoadRecords("$(STD)/stdApp/Db/yySseq.db","P=xxx:,S=Sseq2")
dbLoadRecords("$(STD)/stdApp/Db/yySseq.db","P=xxx:,S=Sseq3")
# 4-step measurement
#dbLoadRecords("$(STD)/stdApp/Db/4step.db", "P=xxx:")

### serial support ###

# generic serial ports
dbLoadRecords("$(IP)/ipApp/Db/generic_serial.db", "P=xxx:,C=0,SERVER=serial1")
dbLoadRecords("$(IP)/ipApp/Db/generic_serial.db", "P=xxx:,C=0,SERVER=serial2")

# serial O/I block (generic serial record with format and parse string calcs)
# on epics/mpf processor
#dbLoadRecords("$(IP)/ipApp/Db/serial_OI_block.db","P=xxx:,N=0_1,C=0,SERVER=serial5")
# on stand-alone mpf processor
#dbLoadRecords("$(IP)/ipApp/Db/serial_OI_block.db","P=xxx:,N=1_1,C=0,SERVER=serial5")

# Stanford Research Systems SR570 Current Preamplifier
#dbLoadRecords("$(IP)/ipApp/Db/SR570.db", "P=xxx:,A=A1,C=0,SERVER=serial1")

# Lakeshore DRC-93CA Temperature Controller
#dbLoadRecords("$(IP)/ipApp/Db/LakeShoreDRC-93CA.db", "P=xxx:,Q=TC1,C=0,SERVER=serial4")

# Huber DMC9200 DC Motor Controller
#dbLoadRecords("$(IP)/ipApp/Db/HuberDMC9200.db", "P=xxx:,Q=DMC1:,C=0,SERVER=serial5")

# Oriel 18011 Encoder Mike
#dbLoadRecords("$(IP)/ipApp/Db/eMike.db", "P=xxx:,M=em1,C=0,SERVER=serial3")

# Keithley 2000 DMM
dbLoadRecords("$(IP)/ipApp/Db/Keithley2kDMM_mf.db","P=xxx:,Dmm=D1,C=0,SERVER=serial2")

# Oxford Cyberstar X1000 Scintillation detector and pulse processing unit
#dbLoadRecords("$(IP)/ipApp/Db/Oxford_X1k.db","P=xxx:,S=s1,C=0,SERVER=serial4")

# Oxford ILM202 Cryogen Level Meter (Serial)
#dbLoadRecords("$(IP)/ipApp/Db/Oxford_ILM202.db","P=xxx:,S=s1,C=0,SERVER=serial5")

# Miscellaneous PV's, such as burtResult
dbLoadRecords("$(STD)/stdApp/Db/misc.db","P=xxx:")

# Elcomat autocollimator
#dbLoadRecords("$(IP)/ipApp/Db/Elcomat.db", "P=xxx:,C=0,SERVER=serial8")

### Queensgate piezo driver
#dbLoadRecords("$(IP)/ipApp/Db/pzt_3id.db","P=xxx:")
#dbLoadRecords("$(IP)/ipApp/Db/pzt.db","P=xxx:")

# Eurotherm temp controller
#dbLoadRecords("$(IP)/ipApp/Db/Eurotherm.db","P=xxx:,C=0,SERVER=serial7")
#var devAoEurothermDebug,20

# MKS vacuum gauges
#dbLoadRecords("$(IP)/ipApp/Db/MKS.db","P=xxx:,C=0,SERVER=serial2,CC1=cc1,CC2=cc3,PR1=pr1,PR2=pr3")
# PI Digitel 500/1500 pump
#dbLoadRecords("$(IP)/ipApp/Db/Digitel.db","xxx:,PUMP=ip1,C=0,SERVER=serial3")
# PI MPC ion pump
#dbLoadRecords("$(IP)/ipApp/Db/MPC.db","P=xxx:,PUMP=ip2,C=0,SERVER=serial4,PA=0,PN=1")
# PI MPC TSP (titanium sublimation pump)
#dbLoadRecords("$(IP)/ipApp/Db/TSP.db","P=xxx:,TSP=tsp1,C=0,SERVER=serial4,PA=0")

# Slow feedback
#dbLoadTemplate("pid_slow.substitutions")


###############################################################################
iocInit

### startup State Notation Language programs
seq &kohzuCtl, "P=xxx:, M_THETA=m1, M_Y=m2, M_Z=m3, GEOM=1, logfile=kohzuCtl.log"
seq &hrCtl, "P=xxx:, N=1, M_PHI1=m1, M_PHI2=m2, logfile=hrCtl1.log"

# Keithley 2000 series DMM
# channels: 10, 20, or 22;  model: 2000 or 2700
seq &Keithley2kDMM,("P=xxx:, Dmm=D1, channels=10, model=2000")

# X-ray Instrumentation Associates Huber Slit Controller
# supported by a SNL program written by Pete Jemian and modified (TMM) for use with the
# sscan record
#seq  &xia_slit, "name=hsc1, P=xxx:, HSC=hsc1:, S=xxx:seriala[6]"

### Start up the autosave task and tell it what to do.
# The task is actually named "save_restore".
# Note that you can reload these sets after creating them: e.g., 
# reload_monitor_set("auto_settings.req",30,"P=xxx:")
#
# save positions every five seconds
create_monitor_set("auto_positions.req",5,"P=xxx:")
# save other things every thirty seconds
create_monitor_set("auto_settings.req",30,"P=xxx:")

