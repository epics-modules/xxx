# vxWorks startup script

# for vxStats
#putenv "engineer=not me"
#putenv "location=Earth"
engineer="not me"
location="Earth"

cd ""
< ../nfsCommands
< cdCommands
#< MPFconfig.cmd

################################################################################
cd topbin

# If the VxWorks kernel was built using the project facility, the following must
# be added before any C++ code is loaded (see SPR #28980).
sysCplusEnable=1

### Load custom EPICS software from user tree and from share
ld < xxx.munch

routerInit
# talk to local IP's
localMessageRouterStart(0)
# talk to IP's on satellite processor
# (must agree with tcpMessageRouterServerStart in st_proc1.cmd)
# for IP modules on stand-alone mpf server board
#tcpMessageRouterClientStart(1, 9900, Remote_IP, 1500, 40)

# For processor with IP slots or that runs a dumb IP carrier
#ld < ip.munch 
#ld < mpfgpibserver.munch 
#ld < mpfserialserver.munch
#ld < dac128V.munch
#ld < ip330.munch
#ld < ip330Serv.munch
#ld < ipUnidig.munch
#ld < loveServer.o
#ld < mpcServer.o

# This IOC configures the MPF server code locally
#cd startup
#< st_mpfserver.cmd
#cd topbin

# For local OR remote GPIB server.  Can't use both (as of mpfGpib1.4)
#ld < GpibHideosLocal.o
#ld < GpibHideosRemote.o

### dbrestore setup
# ok to restore a save set that had missing values (no CA connection to PV)?
sr_restore_incomplete_sets_ok = 1
# dbrestore saves a copy of the save file it restored.  File name is, e.g.,
# auto_settings.sav.bu or auto_settings.savYYMMDD-HHMMSS if
# reboot_restoreDatedBU is nonzero.
reboot_restoreDatedBU = 1;
set_savefile_path(startup, "autosave")
set_requestfile_path(startup, "")
set_requestfile_path(startup, "autosave")
set_requestfile_path(ip, "ipApp/Db")
set_requestfile_path(ip330, "ip330App/Db")
set_requestfile_path(mca, "mcaApp/Db")
set_requestfile_path(ipunidig, "ipUnidigApp/Db")
set_requestfile_path(dac128v, "dac128VApp/Db")
set_requestfile_path(motor, "motorApp/Db")
set_requestfile_path(std, "stdApp/Db")
reboot_restoreDebug=0

# override address, interrupt vector, etc. information in module_types.h
#module_types()

# need more entries in wait/scan-record channel-access queue?
recDynLinkQsize = 1024

# Specify largest array CA will transport
# Note for N sscanRecord data points, need (N+1)*8 bytes, else MEDM
# plot doesn't display
putenv "EPICS_CA_MAX_ARRAY_BYTES=64008"

cd startup
################################################################################
# Tell EPICS all about the record types, device-support modules, drivers,
# etc. in the software we just loaded (xxx.munch)
dbLoadDatabase("../../dbd/iocxxxVX.dbd")
iocxxxVX_registerRecordDeviceDriver(pdbbase)

# Love Controllers
#devLoveDebug=1
#loveServerDebug=1
#dbLoadRecords("$(IP)/ipApp/Db/love.db", "P=xxx:,Q=Love_0,C=0,PORT=PORT2,ADDR=1");

# interpolation
dbLoadRecords("$(STD)/stdApp/Db/interp.db", "P=xxx:")


# X-ray Instrumentation Associates Huber Slit Controller
# supported by a customized version of the SNL program written by Pete Jemian
#dbLoadRecords("$(STD)/stdApp/Db/xia_slit.db", "P=xxx:, HSC=hsc1:")
#dbLoadRecords("$(STD)/stdApp/Db/xia_slit.db", "P=xxx:, HSC=hsc2:")
#dbLoadRecords("$(IP)/ipApp/Db/generic_serial.db", "P=xxx:,C=0,IPSLOT=a,CHAN=6,BAUD=9600,PRTY=None,DBIT=8,SBIT=1")

##### Pico Motors (Ernest Williams MHATT-CAT)
##### Motors (see picMot.substitutions in same directory as this file) ####
#dbLoadTemplate("picMot.substitutions")


##############################################################################

# Insertion-device control
dbLoadRecords("$(STD)/stdApp/Db/IDctrl.db","P=xxx:,xx=02us")

# test generic gpib record
#dbLoadRecords("$(STD)/stdApp/Db/gpib.db","P=xxx:")
# test generic camac record
#dbLoadRecords("$(STD)/stdApp/Db/camac.db","P=xxx:")


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
oms58Setup(3, 8, 0x3000, 190, 5, 10)

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
#     (4)GPIB address or hideos_task name
#MM4000Config(0, 1, 1, "a-Serial[0]")

# Newport PM500 driver setup parameters:
#     (1) maximum number of controllers in system
#     (2) maximum number of channels on any controller
#     (3) motor task polling rate (min=1Hz,max=60Hz)
#PM500Setup(1, 3, 10)

# Newport PM500 configuration parameters:
#     (1) card being configured
#     (2) port type (0-GPIB_PORT, 1-RS232_PORT)
#     (3) link for GPIB or hideos_card for RS-232
#     (3)GPIB link or MPF server location
#     (4) GPIB address (int) or mpf serial server name (string)
#PM500Config(0, 1, 1, "a-Serial[4]")

# A set of scan parameters for each positioner.  This is a convenience
# for the user.  It can contain an entry for each scannable thing in the
# crate.
dbLoadTemplate("scanParms.substitutions")

###############################################################################

### Scalers: Joerger VSC8/16
dbLoadRecords("$(STD)/stdApp/Db/Jscaler.db","P=xxx:,S=scaler1,C=0")
# Joerger VSC setup parameters: 
#     (1)cards, (2)base address(ext, 256-byte boundary), 
#     (3)interrupt vector (0=disable or  64 - 255)
VSCSetup(1, 0x90000000, 200)

### Allstop, alldone
# This database must agree with the motors and other positioners you've actually loaded.
# Several versions (e.g., all_com_32.db) are in stdApp/Db
dbLoadRecords("$(STD)/stdApp/Db/all_com_16.db","P=xxx:")

### Scan-support software
# crate-resident scan.  This executes 1D, 2D, 3D, and 4D scans, and caches
# 1D data, but it doesn't store anything to disk.  (See 'saveData' below for that.)
dbLoadRecords("$(STD)/stdApp/Db/scan.db","P=xxx:,MAXPTS1=4000,MAXPTS2=200,MAXPTS3=10,MAXPTS4=10,MAXPTSH=4000")

# Slits
dbLoadRecords("$(STD)/stdApp/Db/2slit.db","P=xxx:,SLIT=Slit1V,mXp=m3,mXn=m4")
dbLoadRecords("$(STD)/stdApp/Db/2slit.db","P=xxx:,SLIT=Slit1H,mXp=m5,mXn=m6")

# under development...
#dbLoadRecords("$(STD)/stdApp/Db/2slit_soft.db","P=xxx:,SLIT=Slit2V,mXp=m13,mXn=m14")
#dbLoadRecords("$(STD)/stdApp/Db/2slit_soft.db","P=xxx:,SLIT=Slit2H,mXp=m15,mXn=m16")

# 2-post mirror
#dbLoadRecords("$(STD)/stdApp/Db/2postMirror.db","P=xxx:,Q=M1,mDn=m18,mUp=m17,LENGTH=0.3")

# User filters
#dbLoadRecords("$(STD)/stdApp/Db/filterMotor.db","P=xxx:,Q=fltr1:,MOTOR=m1,LOCK=fltr_1_2:")
#dbLoadRecords("$(STD)/stdApp/Db/filterMotor.db","P=xxx:,Q=fltr2:,MOTOR=m2,LOCK=fltr_1_2:")
#dbLoadRecords("$(STD)/stdApp/Db/filterLock.db","P=xxx:,Q=fltr2:,LOCK=fltr_1_2:,LOCK_PV=xxx:DAC1_1.VAL")

# Optical tables
#tableRecordDebug=1
dbLoadRecords("$(STD)/stdApp/Db/table.db","P=xxx:,Q=Table1,T=table1,M0X=m1,M0Y=m2,M1Y=m3,M2X=m4,M2Y=m5,M2Z=m6,GEOM=SRI")

### Monochromator support ###
# Kohzu and PSL monochromators: Bragg and theta/Y/Z motors
# standard geometry (geometry 1)
dbLoadRecords("$(STD)/stdApp/Db/kohzuSeq.db","P=xxx:,M_THETA=m9,M_Y=m10,M_Z=m11,yOffLo=17.4999,yOffHi=17.5001")
# modified geometry (geometry 2)
dbLoadRecords("$(STD)/stdApp/Db/kohzuSeq.db","P=xxx:,M_THETA=m9,M_Y=m10,M_Z=m11,yOffLo=4,yOffHi=36")

# Heidenhain ND261 encoder (for PSL monochromator)
#dbLoadRecords("$(IP)/ipApp/Db/heidND261.db", "P=xxx:,C=0,IPSLOT=a,CHAN=0")

# Heidenhain IK320 VME encoder interpolator
#dbLoadRecords("$(STD)/stdApp/Db/IK320card.db","P=xxx:,sw2=card0:,axis=1,switches=41344,irq=3")
#dbLoadRecords("$(STD)/stdApp/Db/IK320card.db","P=xxx:,sw2=card0:,axis=2,switches=41344,irq=3")
#dbLoadRecords("$(STD)/stdApp/Db/IK320group.db","P=xxx:,group=5")
#drvIK320RegErrStr()

# Spherical grating monochromator
dbLoadRecords("$(STD)/stdApp/Db/SGM.db","P=xxx:,N=1,M_x=m7,M_rIn=m6,M_rOut=m8,M_g=m9")

# 4-bounce high-resolution monochromator
dbLoadRecords("$(STD)/stdApp/Db/hrSeq.db","P=xxx:,N=1,M_PHI1=m9,M_PHI2=m10")
#dbLoadRecords("$(STD)/stdApp/Db/hrSeq.db","P=xxx:,N=2,M_PHI1=m11,M_PHI2=m12")

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
icbSetup("icb/1", 10, 100)

# Configure the new ICB server
# icbConfig(const char *serverName, int module, int enetAddress, int icbAddress)
icbConfig("icb/1", 0, 0x9AA, 3)

# In dbLoadRecords commands for ICB devices
#    CARD   = (0,1) for (local/remote),
#    SERVER = server name supplied as argument to icbConfig(),
#    ADDR   = module number supplied as argument to icbConfig()

dbLoadRecords("$(MCA)/mcaApp/Db/icb_adc.db","P=xxx:,ADC=icbAdc1,CARD=0,SERVER=icb/1,ADDR=0")

#icbConfig("icb/1", 2, 0x9AA, 2)
#dbLoadRecords("$(MCA)/mcaApp/Db/icb_hvps.db","P=xxx:,HVPS=icbHvps1,CARD=0,SERVER=icb/1,ADDR=2")

#icbConfig("icb/1", 3, 0x9AA, 4)
#dbLoadRecords("$(MCA)/mcaApp/Db/icb_amp.db","P=xxx:,AMP=icbAmp1,CARD=0,SERVER=icb/1,ADDR=4")

# icbTcaSetup(char *serverName, int maxModules, int queueSize)
# icbTcaConfig(char *serverName, int module, int enetAddress, int icbAddress)

# icbTcaSetup("icbTca/1", 3, 100)
# icbTcaConfig("icbTca/1", 0, 0x9AA, 1)
#dbLoadRecords("$(MCA)/mcaApp/Db/icb_tca.db","P=xxx:,TCA=icbTca1,MCA=mca1,CARD=0,SERVER=icbTca/1,ADDR=0")

# Load 13 element detector software
#< 13element.cmd

# Load 3 element detector software
#< 3element.cmd

### Struck 7201 multichannel scaler (same as SIS 3806 multichannel scaler)

#mcaRecordDebug = 10
#devSTR7201Debug = 10
#drvSTR7201Debug = 10

#dbLoadRecords("$(MCA)/mcaApp/Db/Struck8.db","P=xxx:mcs:")
#dbLoadRecords("$(MCA)/mcaApp/Db/simple_mca.db","P=xxx:mcs:,M=mca1,DTYP=Struck STR7201 MCS,PREC=3,INP=#C0 S0 @,CHANS=1000")
#dbLoadRecords("$(MCA)/mcaApp/Db/simple_mca.db","P=xxx:mcs:,M=mca2,DTYP=Struck STR7201 MCS,PREC=3,INP=#C0 S1 @,CHANS=1000")
#dbLoadRecords("$(MCA)/mcaApp/Db/simple_mca.db","P=xxx:mcs:,M=mca3,DTYP=Struck STR7201 MCS,PREC=3,INP=#C0 S2 @,CHANS=1000")
#dbLoadRecords("$(MCA)/mcaApp/Db/simple_mca.db","P=xxx:mcs:,M=mca4,DTYP=Struck STR7201 MCS,PREC=3,INP=#C0 S3 @,CHANS=1000")
#dbLoadRecords("$(MCA)/mcaApp/Db/simple_mca.db","P=xxx:mcs:,M=mca5,DTYP=Struck STR7201 MCS,PREC=3,INP=#C0 S4 @,CHANS=1000")
#dbLoadRecords("$(MCA)/mcaApp/Db/simple_mca.db","P=xxx:mcs:,M=mca6,DTYP=Struck STR7201 MCS,PREC=3,INP=#C0 S5 @,CHANS=1000")
#dbLoadRecords("$(MCA)/mcaApp/Db/simple_mca.db","P=xxx:mcs:,M=mca7,DTYP=Struck STR7201 MCS,PREC=3,INP=#C0 S6 @,CHANS=1000")
#dbLoadRecords("$(MCA)/mcaApp/Db/simple_mca.db","P=xxx:mcs:,M=mca8,DTYP=Struck STR7201 MCS,PREC=3,INP=#C0 S7 @,CHANS=1000")

# STR7201Setup(int numCards, int baseAddress, int interruptVector, int interruptLevel)
#STR7201Setup(2, 0xA0000000, 210, 6)
# STR7201Config(int card, int maxSignals, int maxChans, int 1=enable internal 25MHZ clock) 
#STR7201Config(0, 8, 1000, 0) 

### Acromag IP330 in sweep mode ###
#dbLoadRecords("$(MCA)/mcaApp/Db/mca.db", "P=xxx:,M=mADC_1,DTYPE=ip330Sweep,NCHAN=2048,INP=#C0 S0 @d-Ip330Sweep")

### Stuff for user programming ###
dbLoadRecords("$(STD)/stdApp/Db/userCalcs10.db","P=xxx:")
dbLoadRecords("$(STD)/stdApp/Db/userStringCalcs10.db","P=xxx:")
dbLoadRecords("$(STD)/stdApp/Db/userTransforms10.db","P=xxx:")
# extra userCalcs (must also load userCalcs10.db for the enable switch)
dbLoadRecords("$(STD)/stdApp/Db/userCalcN.db","P=xxx:,N=I_Detector")
dbLoadRecords("$(STD)/stdApp/Db/userAve10.db","P=xxx:")
# string sequence (sseq) record
dbLoadRecords("$(STD)/stdApp/Db/yySseq.db","P=xxx:,S=Sseq1")
dbLoadRecords("$(STD)/stdApp/Db/yySseq.db","P=xxx:,S=Sseq2")
dbLoadRecords("$(STD)/stdApp/Db/yySseq.db","P=xxx:,S=Sseq3")
# 4-step measurement
dbLoadRecords("$(STD)/stdApp/Db/4step.db", "P=xxx:")

### serial support ###

# generic serial ports
#dbLoadRecords("$(IP)/ipApp/Db/generic_serial.db", "P=xxx:,C=0,IPSLOT=a,CHAN=0,BAUD=9600,PRTY=None,DBIT=8,SBIT=1")

# serial O/I block (generic serial record with format and parse string calcs)
# on epics/mpf processor
#dbLoadRecords("$(IP)/ipApp/Db/serial_OI_block.db","P=xxx:,N=0_1,C=0,IPSLOT=a,CHAN=4")
# on stand-alone mpf processor
#dbLoadRecords("$(IP)/ipApp/Db/serial_OI_block.db","P=xxx:,N=1_1,C=0,IPSLOT=a,CHAN=4")

# Stanford Research Systems SR570 Current Preamplifier
#dbLoadRecords("$(IP)/ipApp/Db/SR570.db", "P=xxx:,A=A1,C=0,IPSLOT=a,CHAN=0")

# Lakeshore DRC-93CA Temperature Controller
#dbLoadRecords("$(IP)/ipApp/Db/LakeShoreDRC-93CA.db", "P=xxx:,Q=TC1,C=0,IPSLOT=a,CHAN=3")

# Huber DMC9200 DC Motor Controller
#dbLoadRecords("$(IP)/ipApp/Db/HuberDMC9200.db", "P=xxx:,Q=DMC1:,C=0,IPSLOT=a,CHAN=5")

# Oriel 18011 Encoder Mike
#dbLoadRecords("$(IP)/ipApp/Db/eMike.db", "P=xxx:,M=em1,C=0,IPSLOT=a,CHAN=2")

# Keithley 2000 DMM
#dbLoadRecords("$(IP)/ipApp/Db/Keithley2kDMM.db","P=xxx:,Dmm=D1,C=1,IPSLOT=a,CHAN=0")

# Oxford Cyberstar X1000 Scintillation detector and pulse processing unit
#dbLoadRecords("$(IP)/ipApp/Db/Oxford_X1k.db","P=xxx:,S=s1,C=0,IPSLOT=a,CHAN=3")

# Oxford ILM202 Cryogen Level Meter (Serial)
#dbLoadRecords("$(IP)/ipApp/Db/Oxford_ILM202.db","P=xxx:,S=s1,C=0,IPSLOT=c,CHAN=2")

### GPIB support ###
# GPIB O/I block (generic gpib record with format and parse string calcs)
# See HiDEOSGpibLinkConfig() below.
#dbLoadRecords("$(IP)/ipApp/Db/GPIB_OI_block.db","P=xxx:,N=1,L=10")

# Heidenhain AWE1024 at GPIB address $(A)
#dbLoadRecords("$(IP)/ipApp/Db/HeidAWE1024.db", "P=xxx:,L=10,A=6")

# Keithley 199 DMM at GPIB address $(A)
#dbLoadRecords("$(STD)/stdApp/Db/KeithleyDMM.db", "P=xxx:,L=10,A=26")

### Miscellaneous ###
# Systran DAC database
#dbLoadRecords("$(IP)/ipApp/Db/DAC.db", "P=xxx:,D=1,C=1,N=1,S=0,IPSLOT=c")
#dbLoadRecords("$(IP)/ipApp/Db/DAC.db", "P=xxx:,D=1,C=1,N=2,S=1,IPSLOT=c")
#dbLoadRecords("$(IP)/ipApp/Db/DAC.db", "P=xxx:,D=1,C=1,N=3,S=2,IPSLOT=c")
#dbLoadRecords("$(IP)/ipApp/Db/DAC.db", "P=xxx:,D=1,C=1,N=4,S=3,IPSLOT=c")
#dbLoadRecords("$(IP)/ipApp/Db/DAC.db", "P=xxx:,D=1,C=1,N=5,S=4,IPSLOT=c")
#dbLoadRecords("$(IP)/ipApp/Db/DAC.db", "P=xxx:,D=1,C=1,N=6,S=5,IPSLOT=c")
#dbLoadRecords("$(IP)/ipApp/Db/DAC.db", "P=xxx:,D=1,C=1,N=7,S=6,IPSLOT=c")
#dbLoadRecords("$(IP)/ipApp/Db/DAC.db", "P=xxx:,D=1,C=1,N=8,S=7,IPSLOT=c")

# vme test record
dbLoadRecords("$(STD)/stdApp/Db/vme.db", "P=xxx:,Q=vme1")

# Hewlett-Packard 10895A Laser Axis (interferometer)
#dbLoadRecords("$(STD)/stdApp/Db/HPLaserAxis.db", "P=xxx:,Q=HPLaser1, C=0")
# hardware configuration
# example: devHP10895LaserAxisConfig(ncards,a16base)
#devHPLaserAxisConfig(2,0x1000)

# Acromag general purpose Digital I/O
#dbLoadRecords("$(STD)/stdApp/Db/Acromag_16IO.db", "P=xxx:, A=1")

# Acromag AVME9440 setup parameters:
# devAvem9440Config (ncards,a16base,intvecbase)
#devAvme9440Config(1,0x0400,0x78)

# Miscellaneous PV's, such as burtResult
dbLoadRecords("$(STD)/stdApp/Db/misc.db","P=xxx:")
#dbLoadRecords("$(STD)/stdApp/Db/VXstats.db","P=xxx:")
# vxStats
dbLoadTemplate("vxStats.substitutions")

# Elcomat autocollimator
#dbLoadRecords("$(IP)/ipApp/Db/Elcomat.db", "P=xxx:,C=0,IPSLOT=a,CHAN=7")

# Bunch-clock generator
#dbLoadRecords("$(STD)/stdApp/Db/BunchClkGen.db","P=xxx:")
#dbLoadRecords("$(STD)/stdApp/Db/BunchClkGenA.db", "UNIT=xxx", std)
# hardware configuration
# example: BunchClkGenConfigure(intCard, unsigned long CardAddress)
#BunchClkGenConfigure(0, 0x8c00)

### Queensgate piezo driver
#dbLoadRecords("$(STD)/stdApp/Db/pzt_3id.db","P=xxx:")
#dbLoadRecords("$(STD)/stdApp/Db/pzt.db","P=xxx:")

### GP307 Vacuum Controller
#dbLoadRecords("$(STD)/stdApp/Db/gp307.db","P=xxx:")

### Queensgate Nano2k piezo controller
#dbLoadRecords("$(STD)/stdApp/Db/Nano2k.db","P=xxx:,S=s1")

# Eurotherm temp controller
#dbLoadRecords("$(IP)/ipApp/Db/Eurotherm.db","P=xxx:,C=0,IPSLOT=a,CHAN=6")
#devAoEurothermDebug=20

# Analog I/O (Acromag IP330 ADC)
#dbLoadTemplate("ip330Scan.substitutions")

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
#devA32VmeConfig(0, 0xa0000200, 30, 0xa0, 5)

# VVVVVVVVVVVVVVVVVVVVV This doesn't look right (tmm)
#dbLoadRecords("$(STD)/stdApp/Db/msl_mrd100.db","C=0,S=01,ID1=00,ID2=00us")

### Bit Bus configuration
# BBConfig(Link, LinkType, BaseAddr, IrqVector, IrqLevel)
# Link: ?
# LinkType: 0:hosed; 1:xycom; 2:pep
#BBConfig(3,1,0x2400,0xac,5)


###############################################################################
# Set shell prompt (otherwise it is left at mv167 or mv162)
shellPromptSet "iocxxx> "
iocLogDisable=1
iocInit

### startup State Notation Language programs
seq &kohzuCtl, "P=xxx:, M_THETA=m9, M_Y=m10, M_Z=m11, GEOM=1, logfile=kohzuCtl.log"
seq &hrCtl, "P=xxx:, N=1, M_PHI1=m9, M_PHI2=m10, logfile=hrCtl1.log"
#seq &Keithley2kDMM, "P=xxx:, Dmm=D1"

# Bunch clock generator
#seq &getFillPat, "unit=xxx"

# X-ray Instrumentation Associates Huber Slit Controller
# supported by a SNL program written by Pete Jemian and modified (TMM) for use with the
# sscan record
#seq  &xia_slit, "name=hsc1, P=xxx:, HSC=hsc1:, S=xxx:seriala[6]"

### Start up the autosave task and tell it what to do.
# The task is actually named "save_restore".
# (See also, 'initHooks' above, which is the means by which the values that
# will be saved by the task we're starting here are going to be restored.
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
