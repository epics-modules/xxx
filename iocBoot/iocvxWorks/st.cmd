# vxWorks startup script
sysVmeMapShow

# for vxStats
#putenv "engineer=not me"
#putenv "location=Earth"
engineer="not me"
location="Earth"

cd ""
< ../nfsCommands
< cdCommands
< MPFconfig.cmd

################################################################################
cd topbin

# If the VxWorks kernel was built using the project facility, the following must
# be added before any C++ code is loaded (see SPR #28980).
sysCplusEnable=1

# If using a PowerPC CPU with more than 32MB of memory, and not building with longjump, then
# allocate enough memory here to force code to load in lower 32 MB.
mem = malloc(1024*1024*96)

### Load custom EPICS software from user tree and from share
ld < xxx.munch

cd startup

recDynLinkDebug = 1

# Increase size of buffer for error logging from default 1256
errlogInit(5000)

# Note that you need an MPF router not only for IP modules, but also for
# the AIM MCA support and other MPF servers
routerInit
localMessageRouterStart(0)

# This IOC configures the MPF server code locally
#< st_mpfserver.cmd

# override address, interrupt vector, etc. information in module_types.h
#module_types()

# need more entries in wait/scan-record channel-access queue?
recDynLinkQsize = 1024

# Specify largest array CA will transport
# Note for N sscanRecord data points, need (N+1)*8 bytes, else MEDM
# plot doesn't display
putenv "EPICS_CA_MAX_ARRAY_BYTES=64008"

################################################################################
# Tell EPICS all about the record types, device-support modules, drivers,
# etc. in the software we just loaded (xxx.munch)
dbLoadDatabase("../../dbd/iocxxxVX.dbd")
iocxxxVX_registerRecordDeviceDriver(pdbbase)

### save_restore setup
# We presume a suitable initHook routine was compiled into xxx.munch.
# See also create_monitor_set(), after iocInit() .
< save_restore.cmd

##############################################################################

# Insertion-device control
dbLoadRecords("$(STD)/stdApp/Db/IDctrl.db","P=xxx:,xx=02us")

###############################################################################

##### Motors (see motors.substitutions in same directory as this file) ####
#dbLoadTemplate("basic_motor.substitutions")
dbLoadTemplate("motor.substitutions")

# OMS VME driver setup parameters: 
#     (1)cards, (2)axes per card, (3)base address(short, 16-byte boundary), 
#     (4)interrupt vector (0=disable or  64 - 255), (5)interrupt level (1 - 6),
#     (6)motor task polling rate (min=1Hz,max=60Hz)
omsSetup(2, 8, 0xFC00, 180, 5, 10)

# OMS VME58 driver setup parameters: 
#     (1)cards, (2)axes per card, (3)base address(short, 4k boundary), 
#     (4)interrupt vector (0=disable or  64 - 255), (5)interrupt level (1 - 6),
#     (6)motor task polling rate (min=1Hz,max=60Hz)
oms58Setup(3, 8, 0x4000, 190, 5, 10)

# Highland V544 driver setup parameters: 
#     (1)cards, (2)axes per card, (3)base address(short, 4k boundary), 
#     (4)interrupt vector (0=disable or  64 - 255), (5)interrupt level (1 - 6),
#     (6)motor task polling rate (min=1Hz,max=60Hz)
#v544Setup(0, 4, 0xDD00, 0, 5, 10)

# Newport MM4000 driver setup parameters: 
#     (1) max. controllers, (2)Unused, (3)polling rate (min=1Hz,max=60Hz) 
#MM4000Setup(3, 0, 10)

# Newport MM4000 driver configuration parameters: 
#     (1)controller# being configured,
#     (2)port type: 0-GPIB_PORT or 1-RS232_PORT,
#     (3)GPIB link or MPF server location
#     (4) GPIB address (int) or mpf serial server name (string)
#MM4000Config(0, 1, 0, "serial2")

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
#MCB4BConfig(0, 0, "serial5")

##### Pico Motors (Ernest Williams MHATT-CAT)
##### Motors (see picMot.substitutions in same directory as this file) ####
#dbLoadTemplate("picMot.substitutions")

###############################################################################

### Scalers: Joerger VSC8/16
#dbLoadRecords("$(VME)/vmeApp/Db/Jscaler.db","P=xxx:,S=scaler1,C=0")
dbLoadRecords("$(STD)/stdApp/Db/scaler.db","P=xxx:,S=scaler1,C=0,DTYP=Joerger VSC8/16,FREQ=10000000")
# Joerger VSC setup parameters: 
#     (1)cards, (2)base address(ext, 256-byte boundary), 
#     (3)interrupt vector (0=disable or  64 - 255)
VSCSetup(1, 0xB0000000, 200)

### Allstop, alldone
# This database must agree with the motors and other positioners you've actually loaded.
# Several versions (e.g., all_com_32.db) are in stdApp/Db
dbLoadRecords("$(STD)/stdApp/Db/all_com_16.db","P=xxx:")

### Scan-support software
# crate-resident scan.  This executes 1D, 2D, 3D, and 4D scans, and caches
# 1D data, but it doesn't store anything to disk.  (See 'saveData' below for that.)
dbLoadRecords("$(SSCAN)/sscanApp/Db/scan.db","P=xxx:,MAXPTS1=8000,MAXPTS2=200,MAXPTS3=10,MAXPTS4=10,MAXPTSH=8000")

# A set of scan parameters for each positioner.  This is a convenience
# for the user.  It can contain an entry for each scannable thing in the
# crate.
dbLoadTemplate("scanParms.substitutions")

### Slits
dbLoadRecords("$(OPTICS)/opticsApp/Db/2slit.db","P=xxx:,SLIT=Slit1V,mXp=m3,mXn=m4")
dbLoadRecords("$(OPTICS)/opticsApp/Db/2slit.db","P=xxx:,SLIT=Slit1H,mXp=m5,mXn=m6")

# under development...
#dbLoadRecords("$(OPTICS)/opticsApp/Db/2slit_soft.db","P=xxx:,SLIT=Slit2V,mXp=m13,mXn=m14")
#dbLoadRecords("$(OPTICS)/opticsApp/Db/2slit_soft.db","P=xxx:,SLIT=Slit2H,mXp=m15,mXn=m16")

# X-ray Instrumentation Associates Huber Slit Controller
# supported by a customized version of the SNL program written by Pete Jemian
#dbLoadRecords("$(OPTICS)/opticsApp/Db/xia_slit.db", "P=xxx:, HSC=hsc1:")
#dbLoadRecords("$(OPTICS)/opticsApp/Db/xia_slit.db", "P=xxx:, HSC=hsc2:")
#dbLoadRecords("$(IP)/ipApp/Db/generic_serial.db", "P=xxx:,C=0,SERVER=serial7")


### 2-post mirror
#dbLoadRecords("$(OPTICS)/opticsApp/Db/2postMirror.db","P=xxx:,Q=M1,mDn=m18,mUp=m17,LENGTH=0.3")

### User filters
#dbLoadRecords("$(OPTICS)/opticsApp/Db/filterMotor.db","P=xxx:,Q=fltr1:,MOTOR=m1,LOCK=fltr_1_2:")
#dbLoadRecords("$(OPTICS)/opticsApp/Db/filterMotor.db","P=xxx:,Q=fltr2:,MOTOR=m2,LOCK=fltr_1_2:")
#dbLoadRecords("$(OPTICS)/opticsApp/Db/filterLock.db","P=xxx:,Q=fltr2:,LOCK=fltr_1_2:,LOCK_PV=xxx:DAC1_1.VAL")

### Optical tables
#tableRecordDebug=1
dbLoadRecords("$(OPTICS)/opticsApp/Db/table.db","P=xxx:,Q=Table1,T=table1,M0X=m1,M0Y=m2,M1Y=m3,M2X=m4,M2Y=m5,M2Z=m6,GEOM=SRI")

### Monochromator support ###
# Kohzu and PSL monochromators: Bragg and theta/Y/Z motors
# standard geometry (geometry 1)
dbLoadRecords("$(OPTICS)/opticsApp/Db/kohzuSeq.db","P=xxx:,M_THETA=m9,M_Y=m10,M_Z=m11,yOffLo=17.4999,yOffHi=17.5001")
# modified geometry (geometry 2)
dbLoadRecords("$(OPTICS)/opticsApp/Db/kohzuSeq.db","P=xxx:,M_THETA=m9,M_Y=m10,M_Z=m11,yOffLo=4,yOffHi=36")

# Heidenhain ND261 encoder (for PSL monochromator)
#dbLoadRecords("$(IP)/ipApp/Db/heidND261.db", "P=xxx:,C=0,SERVER=serial1")

# Heidenhain IK320 VME encoder interpolator
#dbLoadRecords("$(VME)/vmeApp/Db/IK320card.db","P=xxx:,sw2=card0:,axis=1,switches=41344,irq=3")
#dbLoadRecords("$(VME)/vmeApp/Db/IK320card.db","P=xxx:,sw2=card0:,axis=2,switches=41344,irq=3")
#dbLoadRecords("$(VME)/vmeApp/Db/IK320group.db","P=xxx:,group=5")
#drvIK320RegErrStr()

# Spherical grating monochromator
dbLoadRecords("$(OPTICS)/opticsApp/Db/SGM.db","P=xxx:,N=1,M_x=m7,M_rIn=m6,M_rOut=m8,M_g=m9")

# 4-bounce high-resolution monochromator
dbLoadRecords("$(OPTICS)/opticsApp/Db/hrSeq.db","P=xxx:,N=1,M_PHI1=m9,M_PHI2=m10")
#dbLoadRecords("$(OPTICS)/opticsApp/Db/hrSeq.db","P=xxx:,N=2,M_PHI1=m11,M_PHI2=m12")

### Canberra AIM Multichannel Analyzer ###
#mcaRecordDebug=1
#devMcaMpfDebug=1
#mcaAIMServerDebug=1
#aimDebug=1
#icbDebug=1
#icbServerDebug=1
#icbDspDebug=1
#icbTcaDebug=1

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
#               Typically "ei0" for mv16x, mv17x; "dc0" for Motorola PowerPC
# queueSize:    size of MPF message queue for this server (100 should be plenty)
#
# EXAMPLE:
#   AIMConfig("AIM1/2", 0x9AA, 2, 2048, 1, 1, "dc0", 100)

AIMConfig("AIM1/2", 0x9AA, 2, 4000, 1, 1, "dc0", 100)

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
icbConfig("icb/1", 0, 0x9AA, 3)

# In dbLoadRecords commands for ICB devices
#    CARD   = (0,1) for (local/remote),
#    SERVER = server name supplied as argument to icbConfig(),
#    ADDR   = module number supplied as argument to icbConfig()

dbLoadRecords("$(MCA)/mcaApp/Db/icb_adc.db","P=xxx:,ADC=icbAdc1,CARD=0,SERVER=icb/1,ADDR=0")

#icbConfig("icb/1", 1, 0x9AA, 2)
#dbLoadRecords("$(MCA)/mcaApp/Db/icb_hvps.db","P=xxx:,HVPS=icbHvps1,CARD=0,SERVER=icb/1,ADDR=1")

#icbConfig("icb/1", 2, 0x9AA, 3)
#dbLoadRecords("$(MCA)/mcaApp/Db/icb_amp.db","P=xxx:,AMP=icbAmp1,CARD=0,SERVER=icb/1,ADDR=2")

# icbTcaSetup(char *serverName, int maxModules, int queueSize)
#
# serverName:   defined here, must agree with icbTcaConfig and dbLoadRecords commands
# maxModules:   Maximum number of TCA modules that this server will control
# queueSize:    size of MPF message queue for this server (100 should be plenty)

#icbTcaSetup("icbTca/1", 3, 100)

# icbTcaConfig(char *serverName, int module, int etherAddr, int icbAddress)
#
# serverName:   defined in icbTcaSetup above
# module:       the index number for this module (0,1,2...)
# etherAddr:    ethernet address of AIM module
# icbAddress:   ICB address of this module (set with internal rotary switch, 0x0-0xF)

#icbTcaConfig("icbTca/1", 0, 0x9AA, 4)
#dbLoadRecords("$(MCA)/mcaApp/Db/icb_tca.db","P=xxx:,TCA=icbTca1,MCA=mca1,CARD=0,SERVER=icbTca/1,ADDR=0")

# icbDspSetup(char *serverName, int maxModules, int queueSize)
#
# serverName:   defined here, must agree with icbDspConfig and dbLoadRecords commands
# maxModules:   Maximum number of DSP 9660 modules that this server will control
# queueSize:    size of MPF message queue for this server (100 should be plenty)

#icbDspSetup("icbDsp/1", 3, 100)

# icbDspConfig(char *serverName, int module, int etherAddr, int icbAddress)
#
# serverName:   defined in icbDspSetup above
# module:       the index number for this module (0,1,2...)
# etherAddr:    ethernet address of AIM module
# icbAddress:   ICB address of this module (set with internal rotary switch, 0x0-0xF)

#icbDspConfig("icbDsp/1", 0, 0x9AA, 5)
#dbLoadRecords("$(MCA)/mcaApp/Db/icbDsp.db", "P=xxx:,DSP=dsp1,CARD=0,SERVER=icbDsp/1,ADDR=0")

# Load 13 element detector software
#< 13element.cmd

# Load 3 element detector software
#< 3element.cmd

### Struck 7201 multichannel scaler (same as SIS 3806 multichannel scaler)

#mcaRecordDebug = 10
#devSTR7201Debug = 10
#drvSTR7201Debug = 10

dbLoadRecords("$(MCA)/mcaApp/Db/Struck8.db","P=xxx:mcs:")
dbLoadRecords("$(MCA)/mcaApp/Db/simple_mca.db","P=xxx:mcs:,M=mca1,DTYP=Struck STR7201 MCS,PREC=3,INP=#C0 S0 @,CHANS=1000")
dbLoadRecords("$(MCA)/mcaApp/Db/simple_mca.db","P=xxx:mcs:,M=mca2,DTYP=Struck STR7201 MCS,PREC=3,INP=#C0 S1 @,CHANS=1000")
dbLoadRecords("$(MCA)/mcaApp/Db/simple_mca.db","P=xxx:mcs:,M=mca3,DTYP=Struck STR7201 MCS,PREC=3,INP=#C0 S2 @,CHANS=1000")
dbLoadRecords("$(MCA)/mcaApp/Db/simple_mca.db","P=xxx:mcs:,M=mca4,DTYP=Struck STR7201 MCS,PREC=3,INP=#C0 S3 @,CHANS=1000")
dbLoadRecords("$(MCA)/mcaApp/Db/simple_mca.db","P=xxx:mcs:,M=mca5,DTYP=Struck STR7201 MCS,PREC=3,INP=#C0 S4 @,CHANS=1000")
dbLoadRecords("$(MCA)/mcaApp/Db/simple_mca.db","P=xxx:mcs:,M=mca6,DTYP=Struck STR7201 MCS,PREC=3,INP=#C0 S5 @,CHANS=1000")
dbLoadRecords("$(MCA)/mcaApp/Db/simple_mca.db","P=xxx:mcs:,M=mca7,DTYP=Struck STR7201 MCS,PREC=3,INP=#C0 S6 @,CHANS=1000")
dbLoadRecords("$(MCA)/mcaApp/Db/simple_mca.db","P=xxx:mcs:,M=mca8,DTYP=Struck STR7201 MCS,PREC=3,INP=#C0 S7 @,CHANS=1000")

# STR7201Setup(int numCards, int baseAddress, int interruptVector, int interruptLevel)
STR7201Setup(2, 0x90000000, 220, 6)
# STR7201Config(int card, int maxSignals, int maxChans, int 1=enable internal 25MHZ clock) 
STR7201Config(0, 8, 1000, 0) 

# Struck as EPICS scaler
#dbLoadRecords("$(MCA)/mcaApp/Db/STR7201scaler.db", "P=xxx:,S=scaler2,C=0")
dbLoadRecords("$(STD)/stdApp/Db/scaler.db","P=xxx:,S=scaler2,C=0,DTYP=Struck STR7201 Scaler,FREQ=25000000")

### Acromag IP330 in sweep mode ###
#dbLoadRecords("$(MCA)/mcaApp/Db/mca.db", "P=xxx:,M=mADC_1,DTYPE=MPF MCA,NCHAN=2048,INP=#C0 S0 @Ip330Sweep1")
#dbLoadRecords("$(MCA)/mcaApp/Db/mca.db", "P=xxx:,M=mADC_2,DTYPE=MPF MCA,NCHAN=2048,INP=#C0 S1 @Ip330Sweep1")

### Stuff for user programming ###
dbLoadRecords("$(CALC)/calcApp/Db/userCalcs10.db","P=xxx:")
dbLoadRecords("$(CALC)/calcApp/Db/userStringCalcs10.db","P=xxx:")
dbLoadRecords("$(CALC)/calcApp/Db/userTransforms10.db","P=xxx:")
# extra userCalcs (must also load userCalcs10.db for the enable switch)
dbLoadRecords("$(CALC)/calcApp/Db/userCalcN.db","P=xxx:,N=I_Detector")
dbLoadRecords("$(CALC)/calcApp/Db/userAve10.db","P=xxx:")
# string sequence (sseq) record
dbLoadRecords("$(STD)/stdApp/Db/yySseq.db","P=xxx:,S=Sseq1")
dbLoadRecords("$(STD)/stdApp/Db/yySseq.db","P=xxx:,S=Sseq2")
dbLoadRecords("$(STD)/stdApp/Db/yySseq.db","P=xxx:,S=Sseq3")
# 4-step measurement
dbLoadRecords("$(STD)/stdApp/Db/4step.db", "P=xxx:")
# interpolation
dbLoadRecords("$(CALC)/calcApp/Db/interp.db", "P=xxx:")

### serial support ###

# generic serial ports
#dbLoadRecords("$(IP)/ipApp/Db/generic_serial.db", "P=xxx:,C=0,SERVER=serial1")

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
#dbLoadRecords("$(IP)/ipApp/Db/Keithley2kDMM_mf.db","P=xxx:,Dmm=D1,C=0,SERVER=serial1")

# Oxford Cyberstar X1000 Scintillation detector and pulse processing unit
#dbLoadRecords("$(IP)/ipApp/Db/Oxford_X1k.db","P=xxx:,S=s1,C=0,SERVER=serial4")

# Oxford ILM202 Cryogen Level Meter (Serial)
#dbLoadRecords("$(IP)/ipApp/Db/Oxford_ILM202.db","P=xxx:,S=s1,C=0,SERVER=serial5")

### GPIB support ###
# GPIB O/I block (generic gpib record with format and parse string calcs)
#dbLoadRecords("$(IP)/ipApp/Db/GPIB_OI_block.db","P=xxx:,N=1,L=10")

# Heidenhain AWE1024 at GPIB address $(A)
#dbLoadRecords("$(IP)/ipApp/Db/HeidAWE1024.db", "P=xxx:,L=10,A=6")

# Keithley 199 DMM at GPIB address $(A)
#dbLoadRecords("$(STD)/stdApp/Db/KeithleyDMM.db", "P=xxx:,L=10,A=26")

# generic gpib record
#dbLoadRecords("$(STD)/stdApp/Db/gpib.db","P=xxx:")

### Miscellaneous ###
# Systran DAC database
#dbLoadTemplate("dac128V.substitutions")

# vme test record
dbLoadRecords("$(VME)/vmeApp/Db/vme.db", "P=xxx:,Q=vme1")

# Hewlett-Packard 10895A Laser Axis (interferometer)
#dbLoadRecords("$(VME)/vmeApp/Db/HPLaserAxis.db", "P=xxx:,Q=HPLaser1, C=0")
# hardware configuration
# example: devHP10895LaserAxisConfig(ncards,a16base)
#devHPLaserAxisConfig(2,0x1000)

# Acromag general purpose Digital I/O
#dbLoadRecords("$(VME)/vmeApp/Db/Acromag_16IO.db", "P=xxx:, A=1")

# Acromag AVME9440 setup parameters:
# devAvem9440Config (ncards,a16base,intvecbase)
#devAvme9440Config(1,0x0400,0x78)

# Miscellaneous PV's, such as burtResult
dbLoadRecords("$(STD)/stdApp/Db/misc.db","P=xxx:")
#dbLoadRecords("$(STD)/stdApp/Db/VXstats.db","P=xxx:")
# vxStats
dbLoadTemplate("vxStats.substitutions")

# Elcomat autocollimator
#dbLoadRecords("$(IP)/ipApp/Db/Elcomat.db", "P=xxx:,C=0,SERVER=serial8")

# Bunch-clock generator
#dbLoadRecords("$(VME)/vmeApp/Db/BunchClkGen.db","P=xxx:")
#dbLoadRecords("$(VME)/vmeApp/Db/BunchClkGenA.db", "UNIT=xxx")
# hardware configuration
# example: BunchClkGenConfigure(intCard, unsigned long CardAddress)
#BunchClkGenConfigure(0, 0x8c00)

### Queensgate piezo driver
#dbLoadRecords("$(IP)/ipApp/Db/pzt_3id.db","P=xxx:")
#dbLoadRecords("$(IP)/ipApp/Db/pzt.db","P=xxx:")

### GP307 Vacuum Controller
#dbLoadRecords("$(VME)/vmeApp/Db/gp307.db","P=xxx:")

### Queensgate Nano2k piezo controller
#dbLoadRecords("$(STD)/stdApp/Db/Nano2k.db","P=xxx:,S=s1")

# Eurotherm temp controller
#dbLoadRecords("$(IP)/ipApp/Db/Eurotherm.db","P=xxx:,C=0,SERVER=serial7")
#devAoEurothermDebug=20

# Analog I/O (Acromag IP330 ADC)
dbLoadTemplate("ip330Scan.substitutions")

# Machine-status board (MRD 100)
#####################################################
# dev32VmeConfig(card,a32base,nreg,iVector,iLevel)                 
#    card    = card number                         
#    a32base = base address of card               
#    nreg    = number of A32 registers on this card
#    iVector = interrupt vector (MRD100 Only !!)
#    iLevel  = interrupt level  (MRD100 Only !!)
#  For Example                                     
#   devA32VmeConfig(0, 0x80000000, 44, 0, 0)             
#####################################################
#  Configure the MSL MRD 100 module.....
#devA32VmeConfig(0, 0xB0000200, 30, 0xa0, 5)

#dbLoadRecords("$(STD)/stdApp/Db/msl_mrd101.db","C=0,S=01,ID1=01,ID2=01us")

### Bit Bus configuration
# BBConfig(Link, LinkType, BaseAddr, IrqVector, IrqLevel)
# Link: ?
# LinkType: 0:hosed; 1:xycom; 2:pep
#BBConfig(3,1,0x2400,0xac,5)

# Set up the Allen-Bradley 6008 scanner
#abConfigNlinks 1
#abConfigVme 0,0xc00000,0x60,5
#abConfigAuto

# MKS vacuum gauges
#dbLoadRecords("$(IP)/ipApp/Db/MKS.db","P=xxx:,C=0,SERVER=serial2,CC1=cc1,CC2=cc3,PR1=pr1,PR2=pr3")
# PI Digitel 500/1500 pump
#dbLoadRecords("$(IP)/ipApp/Db/Digitel.db","xxx:,PUMP=ip1,C=0,SERVER=serial3")
# PI MPC ion pump
#dbLoadRecords("$(IP)/ipApp/Db/MPC.db","P=xxx:,PUMP=ip2,C=0,SERVER=serial4,PA=0,PN=1")
# PI MPC TSP (titanium sublimation pump)
#dbLoadRecords("$(IP)/ipApp/Db/TSP.db","P=xxx:,TSP=tsp1,C=0,SERVER=serial4,PA=0")

# APS Quad Electrometer from Steve Ross
# initQuadEM(quadEMName, baseAddress, fiberChannel, microSecondsPerScan, 
#            maxClients, unidigName, unidigChan)
#  quadEMName   = name of quadEM object created
#  baseAddress  = base address of VME card
#  fiberChannel = 0-3, fiber channel number
#  microSecondsPerScan = microseconds to integrate.  When used with ipUnidig
#                 interrupts the unit is also read at this rate.
#  maxClients   = maximum number of clients that will connect to the
#                 quadEM interrupt.  10 should be fine.
#  unidigName   = name of ipInidig server if it is used for interrupts.
#                 Set to 0 if there is no IP-Unidig being used, in which
#                 case the quadEM will be read at 60Hz.
#  unidigChan   = IP-Unidig channel connected to quadEM pulse output
#initQuadEM("quadEM1", 0xf000, 0, 1000, 10, "Unidig1", 2)

# initQuadEMScan(quadEMName, serverName, queueSize)
#  quadEMName = name of quadEM object created with initQuadEM
#  serverName = name of MPF server (string)
#  queueSize  = size of MPF queue
#initQuadEMScan("quadEM1", "quadEM1", 100)

# initQuadEMSweep(quadEMName, serverName, maxPoints, int queueSize)
#  quadEMName = name of quadEM object created with initQuadEM
#  serverName = name of MPF server (string)
#  maxPoints  = maximum number of channels per spectrum
#  queueSize  = size of MPF queue
#initQuadEMSweep("quadEM1", "quadEMSweep", 2048, 400)

# initQuadEMPID(serverName, quadEMName, quadEMChannel,
#               DACName, DACChannel, queueSize)
#  serverName  = name of MPF server (string)
#  quadEMName = name of quadEM object created with initQuadEM
#  quadEMChannel = quadEM "channel" to be used for feedback (0-9)
#                  These are defined as:
#                        0 = current 1
#                        1 = current 2
#                        2 = current 3
#                        3 = current 4
#                        4 = sum 1 = current1 + current3
#                        5 = sum 2 = current2 + current4
#                        6 = difference 1 = current3 - current1
#                        7 = difference 2 = current4 - current2
#                        8 = position 1 = difference1/sum1 * 32767
#                        9 = position 2 = difference2/sum2 * 32767
#  DACName     = name of DAC128V server created with initDAC128V
#  DACVChannel = DAC channel number used for this PID (0-7)
#  queueSize   = size of MPF queue
#initQuadEMPID("quadEMPID1", "quadEM1", 8, "DAC1", 2, 20)
#initQuadEMPID("quadEMPID2", "quadEM1", 9, "DAC1", 3, 20)

#Quad electrometer "scan" ai records
#dbLoadRecords("$(QUADEM)/quadEMApp/Db/quadEM.db","P=xxx:, EM=EM1, CARD=0, SERVER=quadEM1")

### APS Quad Electrometer in sweep mode
#dbLoadRecords("$(MCA)/mcaApp/Db/mca.db", "P=xxx:,M=quadEM_1,DTYPE=MPF MCA,NCHAN=2048,INP=#C0 S0 @quadEMSweep")
#dbLoadRecords("$(MCA)/mcaApp/Db/mca.db", "P=xxx:,M=quadEM_2,DTYPE=MPF MCA,NCHAN=2048,INP=#C0 S1 @quadEMSweep")
#dbLoadRecords("$(MCA)/mcaApp/Db/mca.db", "P=xxx:,M=quadEM_3,DTYPE=MPF MCA,NCHAN=2048,INP=#C0 S2 @quadEMSweep")
#dbLoadRecords("$(MCA)/mcaApp/Db/mca.db", "P=xxx:,M=quadEM_4,DTYPE=MPF MCA,NCHAN=2048,INP=#C0 S3 @quadEMSweep")
#dbLoadRecords("$(MCA)/mcaApp/Db/mca.db", "P=xxx:,M=quadEM_5,DTYPE=MPF MCA,NCHAN=2048,INP=#C0 S8 @quadEMSweep")
#dbLoadRecords("$(MCA)/mcaApp/Db/mca.db", "P=xxx:,M=quadEM_6,DTYPE=MPF MCA,NCHAN=2048,INP=#C0 S9 @quadEMSweep")

# Fast feedback with IP330 and QuadEM
#dbLoadTemplate("pid_fast.substitutions")
# Slow feedback
#dbLoadTemplate("pid_slow.substitutions")

# CAMAC hardware
# Setup the ksc2917 hardware definitions
# These are all actually the defaults, so this is not really necessary
# num_cards, addrs, ivec, irq_level
#ksc2917_setup(1, 0xFF00, 0x00A0, 2)

# Initialize the CAMAC library.  Note that this is normally done automatically
# in iocInit, but we need to get the CAMAC routines working before iocInit
# because we need to initialize the DXP hardware.
#camacLibInit

### E500 Motors
# E500 driver setup parameters:
#     (1) maximum # of controllers,
#     (2) maximum # axis per card
#     (3) motor task polling rate (min=1Hz, max=60Hz)
#E500Setup(2, 8, 10)

# E500 driver configuration parameters:
#     (1) controller
#     (2) branch
#     (3) crate
#     (4) slot
#E500Config(0, 0, 0, 13)
#E500Config(1, 0, 0, 14)

### Scalers: CAMAC scaler
# CAMACScalerSetup(int max_cards)   /* maximum number of logical cards */
#CAMACScalerSetup(1)

# CAMACScalerConfig(int card,       /* logical card */
#  int branch,                         /* CAMAC branch */
#  int crate,                          /* CAMAC crate */
#  int timer_type,                     /* 0=RTC-018 */
#  int timer_slot,                     /* Timer N */
#  int counter_type,                   /* 0=QS-450 */
#  int counter_slot)                   /* Counter N */
#CAMACScalerConfig(0, 0, 0, 0, 20, 0, 21)
#dbLoadRecords("$(CAMAC)/camacApp/Db/CamacScaler.db","P=xxx:,S=scaler1,C=0")
#dbLoadRecords("$(STD)/stdApp/Db/scaler.db","P=xxx:,S=scaler1,C=0,DTYP=CAMAC scaler,FREQ=10000000")

# Load the DXP stuff
#< 16element_dxp.cmd

# Generic CAMAC record
#dbLoadRecords("$(CAMAC)/camacApp/Db/generic_camac.db","P=xxx:,R=camac1,SIZE=2048")

### Etc. ###
# Love Controllers
#devLoveDebug=1
#loveServerDebug=1
#dbLoadRecords("$(IP)/ipApp/Db/love.db", "P=xxx:,Q=Love_0,C=0,PORT=PORT2,ADDR=1");

###############################################################################
# Set shell prompt (otherwise it is left at mv167 or mv162)
shellPromptSet "iocvxWorks> "
iocLogDisable=0
iocInit

### startup State Notation Language programs
seq &kohzuCtl, "P=xxx:, M_THETA=m9, M_Y=m10, M_Z=m11, GEOM=1, logfile=kohzuCtl.log"
seq &hrCtl, "P=xxx:, N=1, M_PHI1=m9, M_PHI2=m10, logfile=hrCtl1.log"

# Keithley 2000 series DMM
# channels: 10, 20, or 22;  model: 2000 or 2700
#seq &Keithley2kDMM,("P=xxx:, Dmm=D1, channels=20, model=2000")

# Bunch clock generator
#seq &getFillPat, "unit=xxx"

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


### Start the saveData task.
# saveData_MessagePolicy
# 0: wait forever for space in message queue, then send message
# 1: send message only if queue is not full
# 2: send message only if queue is not full and specified time has passed (SetCptWait()
#    sets this time.)
# 3: if specified time has passed, wait for space in queue, then send message
# else: don't send message
#debug_saveData = 2
saveData_MessagePolicy = 2
saveData_SetCptWait_ms(100)
saveData_Init("saveData.req", "P=xxx:")
#saveData_PrintScanInfo("xxx:scan1")

# If memory allocated at beginning free it now
free(mem)
