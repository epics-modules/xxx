# vxWorks startup script

cd ""
< ../nfsCommands
< cdCommands
#< MPFconfig.cmd

################################################################################
cd appbin

# If the VxWorks kernel was built using the project facility, the following must
# be added before any C++ code is loaded (see SPR #28980).
sysCplusEnable=1

# If using a PowerPC CPU with more than 32MB of memory, and not building with longjump, then
# allocate enough memory here to force code to load in lower 32 MB
#mem = malloc(1024*1024*96)

### Load EPICS base software
ld < iocCore
ld < seq
ld < mpfLib

### Load custom EPICS software from xxxApp and from share
ld < xxxLib

# Increase size of buffer for error logging from default 1256
errlogInit(5000)

# Note that you need an MPF router not only for IP modules, but also for
# the AIM MCA support.
routerInit
# talk to local IP's
localMessageRouterStart(0)
# talk to IP's on satellite processor
# (must agree with tcpMessageRouterServerStart in st_proc1.cmd)
# for IP modules on stand-alone mpf server board
#tcpMessageRouterClientStart(1, 9900, Remote_IP, 10000, 100)

# for local IP slots or IP slots on a VIPC616 dumb IP carrier
# Uncomment, as needed.
#ld < ipLib
#ld < mpfserialserverLib
#ld < Gpib.o
#ld < gpibSniff.o
#ld < GpibGsTi9914.o
#ld < gpibServer.o
#ld < dac128VLib
#ld < ip330Lib
#ld < ipUnidigLib
#ld < quadEMLib

# This IOC configures the MPF server code locally
#cd startup
#< st_mpfserver.cmd
#cd appbin

# This IOC talks to a local GPIB server
#ld < GpibHideosLocal.o

### save_restore setup
# status-PV prefix
save_restoreSet_status_prefix("xxx:")
# Debug-output level
save_restoreSet_Debug(0)
# Ok to save/restore save sets with missing values (no CA connection to PV)?
save_restoreSet_IncompleteSetsOk(1)
# Save dated backup files?
save_restoreSet_DatedBackupFiles(1)
# Number of sequenced backup files to write
save_restoreSet_NumSeqFiles(3)
# Time interval between sequenced backups
save_restoreSet_SeqPeriodInSeconds(300)
save_restoreSet_NFSHost("oxygen", "164.54.52.4")

# specify where save files should go
set_savefile_path(startup, "autosave")
# specify where request files come from
set_requestfile_path(startup)
set_requestfile_path(std, "stdApp/Db")
set_requestfile_path(motor, "motorApp/Db")
set_requestfile_path(mca, "mcaApp/Db")
set_requestfile_path(ip, "ipApp/Db")
set_requestfile_path(ip330, "ip330App/Db")
set_requestfile_path(dac128v, "dac128VApp/Db")
set_requestfile_path(ipunidig, "ipUnidigApp/Db")
#set_requestfile_path(quadem, "quadEMApp/Db")
#set_requestfile_path(camac, "camacApp/Db")
# specify what save files should be restored.  Note these files must be reachable
# from the directory current at the time iocInit is run
set_pass0_restoreFile("auto_positions.sav")
set_pass0_restoreFile("auto_settings.sav")
set_pass1_restoreFile("auto_settings.sav")

# Currently, the only thing we do in initHooks is call reboot_restore(), which
# restores positions and settings saved ~continuously while EPICS is alive.
# See calls to "create_monitor_set()" at the end of this file.  To disable
# autorestore, comment out the following line.
ld < initHooks.o

# Bunch clock generator
#ld < getFilledBuckets.o

# X-ray Instrumentation Associates Huber Slit Controller
# supported by a customized version of the SNL program written by Pete Jemian
#ld < xia_slit.o

# override address, interrupt vector, etc. information in module_types.h
module_types()

# need more entries in wait/scan-record channel-access queue?
recDynLinkQsize = 1024

cd startup
################################################################################
# Tell EPICS all about the record types, device-support modules, drivers,
# etc. in the software we just loaded (xxxLib)
dbLoadDatabase("../../dbd/xxxApp.dbd")

# Love Controllers
#devLoveDebug=1
#loveServerDebug=1
#dbLoadRecords("ipApp/Db/love.db", "P=xxx:,Q=Love_0,C=0,PORT=PORT2,ADDR=1", ip);

# interpolation
dbLoadRecords("stdApp/Db/interp.db", "P=xxx:", std)

# 4-step measurement
dbLoadRecords("stdApp/Db/4step.db", "P=xxx:", std)

# X-ray Instrumentation Associates Huber Slit Controller
# supported by a customized version of the SNL program written by Pete Jemian
#dbLoadRecords("stdApp/Db/xia_slit.db", "P=xxx:, HSC=hsc1:", std)
#dbLoadRecords("stdApp/Db/xia_slit.db", "P=xxx:, HSC=hsc2:", std)
#dbLoadRecords("ipApp/Db/generic_serial.db", "P=xxx:,C=0,IPSLOT=a,CHAN=6,BAUD=9600,PRTY=None,DBIT=8,SBIT=1", ip)

##### Pico Motors (Ernest Williams MHATT-CAT)
##### Motors (see picMot.substitutions in same directory as this file) ####
#dbLoadTemplate("picMot.substitutions", ip)


##############################################################################

# Insertion-device control
#dbLoadRecords("stdApp/Db/IDctrl.db","P=xxx:,xx=02us", std)
#dbLoadRecords("stdApp/Db/IDctrl.db","P=xxx:,xx=02ds", std)

# test generic gpib record
#dbLoadRecords("stdApp/Db/gpib.db","P=xxx:", std)
# test generic camac record
#dbLoadRecords("stdApp/Db/camac.db","P=xxx:", std)

# string sequence (sseq) record
dbLoadRecords("stdApp/Db/yySseq.db","P=xxx:,S=Sseq1", std)
dbLoadRecords("stdApp/Db/yySseq.db","P=xxx:,S=Sseq2", std)
dbLoadRecords("stdApp/Db/yySseq.db","P=xxx:,S=Sseq3", std)

###############################################################################

##### Motors (see motors.substitutions in same directory as this file) ####
dbLoadTemplate("basic_motor.substitutions")
dbLoadTemplate("motor.substitutions")

# OMS VME driver setup parameters: 
#     (1)cards, (2)axes per card, (3)base address(short, 16-byte boundary), 
#     (4)interrupt vector (0=disable or  64 - 255), (5)interrupt level (1 - 6),
#     (6)motor task polling rate (min=1Hz,max=60Hz)
#omsSetup(2, 8, 0xFC00, 180, 5, 10)

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
#     (1) controller# being configured,
#     (2) port type: 0-GPIB_PORT or 1-RS232_PORT,
#     (3) GPIB link or MPF server location
#     (4) GPIB address (int) or mpf serial server name (string)
#MM4000Config(0, 1, 0, "b-Serial[0]")

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
#PM500Config(0, 1, 0, "b-Serial[1]")

# McClennan PM304 driver setup parameters:
#     (1) maximum number of controllers in system
#     (2) maximum number of channels on any controller
#     (3) motor task polling rate (min=1Hz, max=60Hz)
#PM304Setup(1, 1, 10)

# McClennan PM304 driver configuration parameters:
#     (1) controller being configured
#     (2) MPF server location
#     (3) MPF serial server name (string)
#PM304Config(0, 0, "b-Serial[2]")

# ACS MCB-4B driver setup parameters:
#     (1) maximum number of controllers in system
#     (2) maximum number of axes per controller
#     (3) motor task polling rate (min=1Hz, max=60Hz)
#MCB4BSetup(1, 4, 10)

# ACS MCB-4B driver configuration parameters:
#     (1) controller being configured
#     (2) MPF server location
#     (3) MPF server name (string)
#MCB4BConfig(0, 0, "b-Serial[3]")

# A set of scan parameters for each positioner.  This is a convenience
# for the user.  It can contain an entry for each scannable thing in the
# crate.
dbLoadTemplate("scanParms.substitutions", std)

###############################################################################

### Scalers: Joerger VSC8/16
dbLoadRecords("stdApp/Db/Jscaler.db","P=xxx:,S=scaler1,C=0", std)
# Joerger VSC setup parameters: 
#     (1)cards, (2)base address(ext, 256-byte boundary), 
#     (3)interrupt vector (0=disable or  64 - 255)
VSCSetup(1, 0x90000000, 200)

### Allstop, alldone
# This database must agree with the motors and other positioners you've actually loaded.
# Several versions (e.g., all_com_32.db) are in stdApp/Db
dbLoadRecords("stdApp/Db/all_com_16.db","P=xxx:", std)

### Scan-support software
# crate-resident scan.  This executes 1D, 2D, 3D, and 4D scans, and caches
# 1D data, but it doesn't store anything to disk.  (See 'saveData' below for that.)
dbLoadRecords("stdApp/Db/scan.db","P=xxx:,MAXPTS1=2000,MAXPTS2=200,MAXPTS3=10,MAXPTS4=10,MAXPTSH=2000", std)

# Slits
#dbLoadRecords("stdApp/Db/2slit.db","P=xxx:,SLIT=Slit1V,mXp=m24,mXn=m26", std)
#dbLoadRecords("stdApp/Db/2slit.db","P=xxx:,SLIT=Slit1H,mXp=m23,mXn=m25", std)

# under development...
#dbLoadRecords("stdApp/Db/2slit_soft.db","P=xxx:,SLIT=Slit2V,mXp=m13,mXn=m14", std)
#dbLoadRecords("stdApp/Db/2slit_soft.db","P=xxx:,SLIT=Slit2H,mXp=m15,mXn=m16", std)

# 2-post mirror
#dbLoadRecords("stdApp/Db/2postMirror.db","P=xxx:,Q=M1,mDn=m18,mUp=m17,LENGTH=0.3", std)

# User filters
#dbLoadRecords("stdApp/Db/filterMotor.db","P=xxx:,Q=fltr1:,MOTOR=m1,LOCK=fltr_1_2:", std)
#dbLoadRecords("stdApp/Db/filterMotor.db","P=xxx:,Q=fltr2:,MOTOR=m2,LOCK=fltr_1_2:", std)
#dbLoadRecords("stdApp/Db/filterLock.db","P=xxx:,Q=fltr2:,LOCK=fltr_1_2:,LOCK_PV=xxx:DAC1_1.VAL", std)

# Optical tables
#tableRecordDebug=1
# command line would be too long ( >128 chars). One way to shorten it...
cd std
dbLoadRecords("stdApp/Db/table.db","P=xxx:,Q=Table1,T=table1,M0X=m1,M0Y=m2,M1Y=m3,M2X=m4,M2Y=m5,M2Z=m6,GEOM=SRI")
cd startup

### Monochromator support ###
# Kohzu and PSL monochromators: Bragg and theta/Y/Z motors
# standard geometry (geometry 1)
#dbLoadRecords("stdApp/Db/kohzuSeq.db","P=xxx:,M_THETA=m9,M_Y=m10,M_Z=m11,yOffLo=17.4999,yOffHi=17.5001", std)
# modified geometry (geometry 2)
#dbLoadRecords("stdApp/Db/kohzuSeq.db","P=xxx:,M_THETA=m9,M_Y=m10,M_Z=m11,yOffLo=4,yOffHi=36", std)

# Heidenhain ND261 encoder (for PSL monochromator)
#dbLoadRecords("ipApp/Db/heidND261.db", "P=xxx:,C=0,IPSLOT=a,CHAN=0", ip)

# Heidenhain IK320 VME encoder interpolator
#dbLoadRecords("stdApp/Db/IK320card.db","P=xxx:,sw2=card0:,axis=1,switches=41344,irq=3", std)
#dbLoadRecords("stdApp/Db/IK320card.db","P=xxx:,sw2=card0:,axis=2,switches=41344,irq=3", std)
#dbLoadRecords("stdApp/Db/IK320group.db","P=xxx:,group=5", std)
#drvIK320RegErrStr()

# Spherical grating monochromator
#dbLoadRecords("stdApp/Db/SGM.db","P=xxx:,N=1,M_x=m7,M_rIn=m6,M_rOut=m8,M_g=m9", std)

# 4-bounce high-resolution monochromator
#dbLoadRecords("stdApp/Db/hrSeq.db","P=xxx:,N=1,M_PHI1=m9,M_PHI2=m10", std)

### Canberra AIM Multichannel Analyzer ###
#
# Make sure you're calling 'routerInit'and 'localMessageRouterStart(0) above
# (or tcpMessageRouterClientStart(), if you know what you're doing.)
#
#mcaRecordDebug=0
#devMcaMpfDebug=0
#mcaAIMServerDebug=0
#aimDebug=0

# AIMConfig(serverName, int etherAddr, int port, int maxChans, 
#	int maxSignals, int maxSequences, char *etherDev, queueSize)
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
#AIMConfig("AIM1/2", 0x9AA, 2, 2048, 1, 1, "dc0", 100)

#dbLoadRecords("mcaApp/Db/mca.db","P=xxx:,M=mca1,INP=#C0 S0 @AIM1/2,DTYPE=MPF MCA,NCHAN=2048", mca)

# Create ICB server for ADC, amplifier and HVPS
# picbServer = icbConfig(icbServer, maxModules, icbAddress, queueSize)
# This creates the ICB server and allocates configures the first module, module 0.
# Additional modules are added to this server with icbAddModule().
#picbServer = icbConfig("icb/1", 5, "NI9AA:3", 100)

# In the dbLoadRecords commands CARD=(0,1) for (local/remote), SERVER=icbServer name from
# icbConfig, ADDR=module number from icbConfig() or icbAddModule().
#icbAddModule(picbServer, module, icbAddress)
# Note: ADDR is the module number, not the icb address.  The correspondence between
# module number and icb address is made in icbConfig (for module number 0) or in
# icbAddModule.
#dbLoadRecords("mcaApp/Db/icb_adc.db","P=xxx:,ADC=icbAdc1,CARD=0,SERVER=icb/1,ADDR=0", mca)

#icbAddModule(picbServer, 1, "NI9AA:2")
#dbLoadRecords("mcaApp/Db/icb_hvps.db","P=xxx:,HVPS=icbHvps1,CARD=0,SERVER=icb/1,ADDR=1,LIMIT=1000", mca)

#icbAddModule(picbServer, 2, "NI9AA:4")
#dbLoadRecords("mcaApp/Db/icb_amp.db","P=xxx:,AMP=icbAmp1,CARD=0,SERVER=icb/1,ADDR=2", mca)

#icbTcaConfig("icbTca/1", 1, "NI9AA:1", 100)
#dbLoadRecords("mcaApp/Db/icb_tca.db","P=xxx:,TCA=icbTca1,MCA=mca1,CARD=0,SERVER=icb/1,ADDR=1", mca)

#icbDspConfig("icbDsp/1", 1, "NI9AA:5", 100)
#dbLoadRecords "mcaApp/Db/icbDsp.db", "P=xxx:,DSP=dsp1,CARD=0,SERVER=icbDsp/1,ADDR=0", mca

# Load 13 element detector software
#< 13element.cmd

# Load 3 element detector software
#< 3element.cmd

### Struck 7201 multichannel scaler (same as SIS 3806 multichannel scaler)

#mcaRecordDebug = 10
#devSTR7201Debug = 10
#drvSTR7201Debug = 10

#dbLoadRecords("mcaApp/Db/Struck8.db","P=xxx:mcs:", mca)
#dbLoadRecords("mcaApp/Db/simple_mca.db","P=xxx:mcs:,M=mca1,DTYP=Struck STR7201 MCS,PREC=3,INP=#C0 S0 @,CHANS=1000", mca)
#dbLoadRecords("mcaApp/Db/simple_mca.db","P=xxx:mcs:,M=mca2,DTYP=Struck STR7201 MCS,PREC=3,INP=#C0 S1 @,CHANS=1000", mca)
#dbLoadRecords("mcaApp/Db/simple_mca.db","P=xxx:mcs:,M=mca3,DTYP=Struck STR7201 MCS,PREC=3,INP=#C0 S2 @,CHANS=1000", mca)
#dbLoadRecords("mcaApp/Db/simple_mca.db","P=xxx:mcs:,M=mca4,DTYP=Struck STR7201 MCS,PREC=3,INP=#C0 S3 @,CHANS=1000", mca)
#dbLoadRecords("mcaApp/Db/simple_mca.db","P=xxx:mcs:,M=mca5,DTYP=Struck STR7201 MCS,PREC=3,INP=#C0 S4 @,CHANS=1000", mca)
#dbLoadRecords("mcaApp/Db/simple_mca.db","P=xxx:mcs:,M=mca6,DTYP=Struck STR7201 MCS,PREC=3,INP=#C0 S5 @,CHANS=1000", mca)
#dbLoadRecords("mcaApp/Db/simple_mca.db","P=xxx:mcs:,M=mca7,DTYP=Struck STR7201 MCS,PREC=3,INP=#C0 S6 @,CHANS=1000", mca)
#dbLoadRecords("mcaApp/Db/simple_mca.db","P=xxx:mcs:,M=mca8,DTYP=Struck STR7201 MCS,PREC=3,INP=#C0 S7 @,CHANS=1000", mca)

# STR7201Setup(int numCards, int baseAddress, int interruptVector, int interruptLevel)
#STR7201Setup(2, 0xA0000000, 210, 6)
# STR7201Config(int card, int maxSignals, int maxChans, int 1=enable internal 25MHZ clock) 
#STR7201Config(0, 8, 1000, 0) 

### Acromag IP330 in sweep mode ###
#dbLoadRecords("mcaApp/Db/mca.db", "P=xxx:,M=mADC_1,DTYPE=MPF MCA,NCHAN=2048,INP=#C0 S0 @d-Ip330Sweep", mca)
#dbLoadRecords("mcaApp/Db/mca.db", "P=xxx:,M=mADC_2,DTYPE=MPF MCA,NCHAN=2048,INP=#C0 S1 @d-Ip330Sweep", mca)

### Stand-alone user calculations ###
dbLoadRecords("stdApp/Db/userCalcs10.db","P=xxx:", std)
dbLoadRecords("stdApp/Db/userStringCalcs10.db","P=xxx:", std)
dbLoadRecords("stdApp/Db/userTransforms10.db","P=xxx:", std)
# extra userCalcs (must also load userCalcs10.db for the enable switch)
dbLoadRecords("stdApp/Db/userCalcN.db","P=xxx:,N=I_Detector", std)
dbLoadRecords("stdApp/Db/userAve10.db","P=xxx:", std)

### serial support ###

# generic serial ports
#dbLoadRecords("ipApp/Db/generic_serial.db", "P=xxx:,C=0,IPSLOT=a,CHAN=0,BAUD=9600,PRTY=None,DBIT=8,SBIT=1", ip)

# serial O/I block (generic serial record with format and parse string calcs)
# on epics/mpf processor
#dbLoadRecords("ipApp/Db/serial_OI_block.db","P=xxx:,N=0_1,C=0,IPSLOT=a,CHAN=4", ip)
# on stand-alone mpf processor
#dbLoadRecords("ipApp/Db/serial_OI_block.db","P=xxx:,N=1_1,C=0,IPSLOT=a,CHAN=4", ip)

# Stanford Research Systems SR570 Current Preamplifier
#dbLoadRecords("ipApp/Db/SR570.db", "P=xxx:,A=A1,C=0,IPSLOT=a,CHAN=0", ip)

# Lakeshore DRC-93CA Temperature Controller
#dbLoadRecords("ipApp/Db/LakeShoreDRC-93CA.db", "P=xxx:,Q=TC1,C=0,IPSLOT=a,CHAN=3", ip)

# Huber DMC9200 DC Motor Controller
#dbLoadRecords("ipApp/Db/HuberDMC9200.db", "P=xxx:,Q=DMC1:,C=0,IPSLOT=a,CHAN=5", ip)

# Oriel 18011 Encoder Mike
#dbLoadRecords("ipApp/Db/eMike.db", "P=xxx:,M=em1,C=0,IPSLOT=a,CHAN=2", ip)

# Keithley 2000 DMM
#dbLoadRecords("ipApp/Db/Keithley2kDMM_mf.db","P=xxx:,Dmm=D1,C=0,IPSLOT=a,CHAN=5", ip)

# Oxford Cyberstar X1000 Scintillation detector and pulse processing unit
#dbLoadRecords("ipApp/Db/Oxford_X1k.db","P=xxx:,S=s1,C=0,IPSLOT=a,CHAN=3", ip)

# Oxford ILM202 Cryogen Level Meter (Serial)
#dbLoadRecords("ipApp/Db/Oxford_ILM202.db","P=xxx:,S=s1,C=0,IPSLOT=c,CHAN=6", ip)

### GPIB support ###
# GPIB O/I block (generic gpib record with format and parse string calcs)
# See HiDEOSGpibLinkConfig() below.
#dbLoadRecords("ipApp/Db/GPIB_OI_block.db","P=xxx:,N=1,L=10", ip)

# Heidenhain AWE1024 at GPIB address $(A)
#dbLoadRecords("ipApp/Db/HeidAWE1024.db", "P=xxx:,L=10,A=6", ip)

# Keithley 199 DMM at GPIB address $(A)
#dbLoadRecords("stdApp/Db/KeithleyDMM.db", "P=xxx:,L=10,A=26", std)

### Miscellaneous ###
# Systran DAC database
#dbLoadRecords("ipApp/Db/DAC.db", "P=xxx:,D=1,C=0,N=1,S=0,IPSLOT=c", ip)
#dbLoadRecords("ipApp/Db/DAC.db", "P=xxx:,D=1,C=0,N=2,S=1,IPSLOT=c", ip)
#dbLoadRecords("ipApp/Db/DAC.db", "P=xxx:,D=1,C=0,N=3,S=2,IPSLOT=c", ip)
#dbLoadRecords("ipApp/Db/DAC.db", "P=xxx:,D=1,C=0,N=4,S=3,IPSLOT=c", ip)
#dbLoadRecords("ipApp/Db/DAC.db", "P=xxx:,D=1,C=0,N=5,S=4,IPSLOT=c", ip)
#dbLoadRecords("ipApp/Db/DAC.db", "P=xxx:,D=1,C=0,N=6,S=5,IPSLOT=c", ip)
#dbLoadRecords("ipApp/Db/DAC.db", "P=xxx:,D=1,C=0,N=7,S=6,IPSLOT=c", ip)
#dbLoadRecords("ipApp/Db/DAC.db", "P=xxx:,D=1,C=0,N=8,S=7,IPSLOT=c", ip)

# vme test record
#dbLoadRecords("stdApp/Db/vme.db", "P=xxx:,Q=vme1", std)

# Hewlett-Packard 10895A Laser Axis (interferometer)
#dbLoadRecords("stdApp/Db/HPLaserAxis.db", "P=xxx:,Q=HPLaser1, C=0", std)
# hardware configuration
# example: devHP10895LaserAxisConfig(ncards,a16base)
#devHPLaserAxisConfig(2,0x1000)

# IpUnidig digital I/O
dbLoadTemplate("IpUnidig.substitutions")

# Acromag general purpose Digital I/O
#dbLoadRecords("stdApp/Db/Acromag_16IO.db", "P=xxx:, A=1", std)

# Acromag AVME9440 setup parameters:
# devAvem9440Config (ncards,a16base,intvecbase)
#devAvme9440Config(1,0x0400,0x78)

# Miscellaneous PV's, such as burtResult
dbLoadRecords("stdApp/Db/misc.db","P=xxx:", std)
dbLoadRecords("stdApp/Db/VXstats.db","P=xxx:", std)

# Elcomat autocollimator
#dbLoadRecords("ipApp/Db/Elcomat.db", "P=xxx:,C=0,IPSLOT=a,CHAN=7", ip)

# Bunch-clock generator
#dbLoadRecords("stdApp/Db/BunchClkGen.db","P=xxx:", std)
#dbLoadRecords("stdApp/Db/BunchClkGenA.db", "UNIT=xxx", std)
# hardware configuration
# example: BunchClkGenConfigure(intCard, unsigned long CardAddress)
#BunchClkGenConfigure(0, 0x8c00)

### Queensgate piezo driver
#dbLoadRecords("stdApp/Db/pzt_3id.db","P=xxx:", std)
#dbLoadRecords("stdApp/Db/pzt.db","P=xxx:", std)

### GP307 Vacuum Controller
#dbLoadRecords("stdApp/Db/gp307.db","P=xxx:", std)

### Queensgate Nano2k piezo controller
#dbLoadRecords("stdApp/Db/Nano2k.db","P=xxx:,S=s1", std)

# Eurotherm temp controller
#dbLoadRecords("ipApp/Db/Eurotherm.db","P=xxx:,C=0,IPSLOT=a,CHAN=6", ip)
#devAoEurothermDebug=20

# Analog I/O (Acromag IP330 ADC)
#dbLoadTemplate("ip330Scan.substitutions", ip330)

# PV save_restore can use to report its status
dbLoadRecords("stdApp/Db/save_restoreStatus.db","P=xxx:", std)

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

#dbLoadRecords("stdApp/Db/msl_mrd101.db","C=0,S=01,ID1=01,ID2=01us", std)

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
#dbLoadRecords "ipApp/Db/MKS.db","P=xxx:,C=0,IPSLOT=a,CHAN=1,CC1=cc1,CC2=cc3,PR1=pr1,PR2=pr3", ip
# PI Digitel 500/1500 pump
#dbLoadRecords "ipApp/Db/Digitel.db","xxx:,PUMP=ip1,C=0,IPSLOT=a,CHAN=2", ip
# PI MPC ion pump
#dbLoadRecords("ipApp/Db/MPC.db","P=xxx:,PUMP=ip2,C=0,IPSLOT=a,CHAN=3,PA=0,PN=1", ip
# PI MPC TSP (titanium sublimation pump)
#dbLoadRecords("ipApp/Db/TSP.db","P=xxx:,TSP=tsp1,C=0,IPSLOT=b,CHAN=3,PA=0", ip)

# APS Quad Electrometer from Steve Ross
# pQuadEM = initQuadEM(baseAddress, fiberChannel, microSecondsPerScan, maxClients,
#            pIpUnidig, unidigChan)
#  pQuadEM       = Pointer to MPF server
#  baseAddress   = base address of VME card
#  fiberChannel = 0-3, fiber channel number
#  microSecondsPerScan = microseconds to integrate.  When used with ipUnidig
#                interrupts the unit is also read at this rate.
#  maxClients  = maximum number of clients that will connect to the
#                quadEM interrupt.  10 should be fine.
#  iIpUnidig   = pointer to ipInidig object if it is used for interrupts.
#                Set to 0 if there is no IP-Unidig being used, in which
#                case the quadEM will be read at 60Hz.
#  unidigChan  = IP-Unidig channel connected to quadEM pulse output
#pQuadEM = initQuadEM(0xf000, 0, 1000, 10, pIpUnidig, 2)

# initQuadEMScan(pQuadEM, serverName, queueSize)
#  pQuadEM    = pointer to quadEM object created with initQuadEM
#  serverName = name of MPF server (string)
#  queueSize  = size of MPF queue
#initQuadEMScan(pQuadEM, "quadEM1", 100)

# initQuadEMSweep(pquadEM, serverName, maxPoints, int queueSize)
#  pQuadEM    = pointer to quadEM object created with initQuadEM
#  serverName = name of MPF server (string)
#  maxPoints  = maximum number of channels per spectrum
#  queueSize  = size of MPF queue
#initQuadEMSweep(pQuadEM, "quadEMSweep", 2048, 100)

# initQuadEMPID(serverName, pQuadEM, quadEMChannel,
#               pDAC128V, DACChannel, queueSize)
#  serverName  = name of MPF server (string)
#  pQuadEM     = pointer to quadEM object created with initQuadEM
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
#  pDAC128V    = pointer to DAC128V object created with initDAC128V
#  DACVChannel = DAC channel number used for this PID (0-7)
#  queueSize   = size of MPF queue
#initQuadEMPID("quadEMPID1", pQuadEM, 8, pDAC128V, 2, 20)
#initQuadEMPID("quadEMPID2", pQuadEM, 9, pDAC128V, 3, 20)

#Quad electrometer "scan" ai records
#dbLoadRecords("quadEMApp/Db/quadEM.db","P=xxx:, EM=EM1, CARD=0, SERVER=quadEM1", quadem)

### APS Quad Electrometer in sweep mode
#dbLoadRecords("mcaApp/Db/mca.db", "P=xxx:,M=quadEM_1,DTYPE=MPF MCA,NCHAN=2048,INP=#C0 S0 @quadEMSweep", mca)
#dbLoadRecords("mcaApp/Db/mca.db", "P=xxx:,M=quadEM_2,DTYPE=MPF MCA,NCHAN=2048,INP=#C0 S1 @quadEMSweep", mca)
#dbLoadRecords("mcaApp/Db/mca.db", "P=xxx:,M=quadEM_3,DTYPE=MPF MCA,NCHAN=2048,INP=#C0 S2 @quadEMSweep", mca)
#dbLoadRecords("mcaApp/Db/mca.db", "P=xxx:,M=quadEM_4,DTYPE=MPF MCA,NCHAN=2048,INP=#C0 S3 @quadEMSweep", mca)
#dbLoadRecords("mcaApp/Db/mca.db", "P=xxx:,M=quadEM_5,DTYPE=MPF MCA,NCHAN=2048,INP=#C0 S8 @quadEMSweep", mca)
#dbLoadRecords("mcaApp/Db/mca.db", "P=xxx:,M=quadEM_6,DTYPE=MPF MCA,NCHAN=2048,INP=#C0 S9 @quadEMSweep", mca)

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
#dbLoadRecords("camacApp/Db/CamacScaler.db","P=xxx:,S=scaler1,C=0", camac)

# Load the DXP stuff
#< 16element_dxp.cmd

# Generic CAMAC record
#dbLoadRecords("camacApp/Db/generic_camac.db","P=xxx:,R=camac1,SIZE=2048", camac)

#

###############################################################################
# Set shell prompt (otherwise it is left at mv167 or mv162)
shellPromptSet "iocxxx> "
#reboot_restoreDebug=5
iocLogDisable=1
iocInit

### startup State Notation Language programs
#seq &kohzuCtl, "P=xxx:, M_THETA=m9, M_Y=m10, M_Z=m11, GEOM=1, logfile=kohzuCtl.log"
#seq &hrCtl, "P=xxx:, N=1, M_PHI1=m9, M_PHI2=m10, logfile=hrCtl1.log"

# Keithley 2000 series DMM
# channels: 10, 20, or 22;  model: 2000 or 2700
#seq &Keithley2kDMM,("P=xxx:, Dmm=D1, channels=20, model=2000")

# Bunch clock generator
#seq &getFillPat, "unit=xxx"

# X-ray Instrumentation Associates Huber Slit Controller
# supported by a SNL program written by Pete Jemian and modified (tmm) for use with the
# sscan record
#seq  &xia_slit, "name=hsc1, P=xxx:, HSC=hsc1:, S=xxx:seriala[6]"

### Start up the autosave task and tell it what to do.
# The task is actually named "save_restore".
# (See also, 'initHooks' above, which is the means by which the values that
# will be saved by the task we're starting here are going to be restored.
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

# If memory was malloced at start of this script, free it
#free(mem)
