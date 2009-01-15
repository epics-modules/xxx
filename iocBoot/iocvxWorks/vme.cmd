
# BEGIN vme.cmd ---------------------------------------------------------------

##### Motors

# OMS VME driver setup parameters:
#     (1)cards, (2)base address(short, 16-byte boundary),
#     (3)interrupt vector (0=disable or  64 - 255), (4)interrupt level (1 - 6),
#     (5)motor task polling rate (min=1Hz,max=60Hz)
omsSetup(2, 0xFC00, 180, 5, 10)

# OMS VME58 driver setup parameters:
#     (1)cards, (2)base address(short, 4k boundary),                  
#     (3)interrupt vector (0=disable or  64 - 255), (4)interrupt level (1 - 6),
#     (5)motor task polling rate (min=1Hz,max=60Hz)
oms58Setup(2, 0x4000, 190, 5, 10)

# OMS MAXv driver setup parameters: 
#     (1)number of cards in array.
#     (2)VME Address Type (16,24,32).
#     (3)Base Address on 4K (0x1000) boundary.
#     (4)interrupt vector (0=disable or  64 - 255).
#     (5)interrupt level (1 - 6).
#     (6)motor task polling rate (min=1Hz,max=60Hz).
#!MAXvSetup(1, 16, 0xF000,     190, 5, 10)
#!MAXvSetup(1, 24, 0xF00000,   190, 5, 10)
#!MAXvSetup(1, 32, 0xB0000000, 190, 5, 10)
#!drvMAXvdebug=4

# OMS MAXv configuration string:
#     (1) number of card being configured (0-14).
#     (2) configuration string; axis type (PSO/PSE/PSM) MUST be set here.
#         For example, set which TTL signal level defines
#         an active limit switch.  Set X,Y,Z,T to active low and set U,V,R,S
#         to active high.  Set all axes to open-loop stepper (PSO). See MAXv
#         User's Manual for LL/LH and PSO/PSE/PSM commands.
#config0="AX LL PSO; AY LL PSO; AZ LL PSO; AT LL PSO; AU LH PSO; AV LH PSO; AR LH PSO; AS LH PSO;"

#!config0="AX LH PSM; AY LL PSO; AZ LL PSO; AT LL PSO; AU LH PSO; AV LH PSO; AR LH PSO; AS LH PSO;"
#!MAXvConfig(0, config0)

### Scalers: Joerger VSC8/16
#dbLoadRecords("$(STD)/stdApp/Db/scaler.db","P=xxx:,S=scaler1,OUT=#C1 S0 @,DTYP=Joerger VSC8/16,FREQ=10000000")
# scaler database with modified calcs (user calcs for all 16 channels)
dbLoadRecords("$(STD)/stdApp/Db/scaler16m.db","P=xxx:,S=scaler1,OUT=#C0 S0 @,DTYP=Joerger VSC8/16,FREQ=10000000")
# Joerger VSC setup parameters:
#     (1)cards, (2)base address(ext, 256-byte boundary),
#     (3)interrupt vector (0=disable or  64 - 255)
VSCSetup(2, 0xB0000000, 200)

# Joerger VS
# scalerVS_Setup(int num_cards, /* maximum number of cards in crate */
#       char *addrs,            /* address (0x800-0xf800, 2048-byte (0x800) boundary) */
#       unsigned vector,        /* valid vectors(64-255) */
#       int intlevel)
#scalerVS_Setup(1, 0x2000, 205, 5)
#devScaler_VSDebug=0
#dbLoadRecords("$(STD)/stdApp/Db/scaler16m.db","P=xxx:,S=scaler3,OUT=#C0 S0 @, DTYP=Joerger VS, FREQ=10000000")

# Heidenhain IK320 VME encoder interpolator
#dbLoadRecords("$(VME)/vmeApp/Db/IK320card.db","P=xxx:,sw2=card0:,axis=1,switches=41344,irq=3")
#dbLoadRecords("$(VME)/vmeApp/Db/IK320card.db","P=xxx:,sw2=card0:,axis=2,switches=41344,irq=3")
#dbLoadRecords("$(VME)/vmeApp/Db/IK320group.db","P=xxx:,group=5")

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

# Note the address 0x9000000 does not work on an MVME5100; try 0xA0000000
# STR7201Setup(int numCards, int baseAddress, int interruptVector, int interruptLevel)
#STR7201Setup(2, 0xA0000000, 220, 6)
# STR7201Config(int card, int maxSignals, int maxChans, 
#               int 1=enable internal 25MHZ clock, 
#               int 1=enable initial software channel advance in MCS external advance mode)
#STR7201Config(0, 8, 1000, 1, 1)

# Struck as EPICS scaler
#dbLoadRecords("$(STD)/stdApp/Db/scaler.db","P=xxx:,S=scaler2,OUT=#C0 S0 @,DTYP=Struck STR7201 Scaler,FREQ=25000000")

# VMI4116 setup parameters: 
#     (1)cards, (2)base address(short, 36-byte boundary), 
#devAoVMI4116Debug = 20
#VMI4116_setup(1, 0xff00)
#dbLoadRecords("$(VME)/vmeApp/Db/VME_DAC.db", "P=xxx:,D=2,C=0,N=1,S=0,DTYP=VMIVME-4116,H=65536,L=0", std)
#dbLoadRecords("$(VME)/vmeApp/Db/VME_DAC.db", "P=xxx:,D=2,C=0,N=2,S=1,DTYP=VMIVME-4116,H=65536,L=0", std)
#dbLoadRecords("$(VME)/vmeApp/Db/VME_DAC.db", "P=xxx:,D=2,C=0,N=3,S=2,DTYP=VMIVME-4116,H=65536,L=0", std)
#dbLoadRecords("$(VME)/vmeApp/Db/VME_DAC.db", "P=xxx:,D=2,C=0,N=4,S=3,DTYP=VMIVME-4116,H=65536,L=0", std)
#dbLoadRecords("$(VME)/vmeApp/Db/VME_DAC.db", "P=xxx:,D=2,C=0,N=5,S=4,DTYP=VMIVME-4116,H=65536,L=0", std)
#dbLoadRecords("$(VME)/vmeApp/Db/VME_DAC.db", "P=xxx:,D=2,C=0,N=6,S=5,DTYP=VMIVME-4116,H=65536,L=0", std)
#dbLoadRecords("$(VME)/vmeApp/Db/VME_DAC.db", "P=xxx:,D=2,C=0,N=7,S=6,DTYP=VMIVME-4116,H=65536,L=0", std)
#dbLoadRecords("$(VME)/vmeApp/Db/VME_DAC.db", "P=xxx:,D=2,C=0,N=8,S=7,DTYP=VMIVME-4116,H=65536,L=0", std)

# vme test record
dbLoadRecords("$(VME)/vmeApp/Db/vme.db", "P=xxx:,Q=vme1")

# Hewlett-Packard 10895A Laser Axis (interferometer)
#dbLoadRecords("$(VME)/vmeApp/Db/HPLaserAxis.db", "P=xxx:,Q=HPLaser1, C=0")
# hardware configuration
# example: devHP10895LaserAxisConfig(ncards,a16base)
#devHPLaserAxisConfig(2,0x1000)

# Acromag general purpose Digital I/O
#dbLoadRecords("$(VME)/vmeApp/Db/Acromag_16IO.db", "P=xxx:, A=1, C=0")

# Acromag AVME9440 setup parameters:
# devAvem9440Config (ncards,a16base,intvecbase)
#devAvme9440Config(1,0x0400,0x78)

# Bunch-clock generator
#dbLoadRecords("$(VME)/vmeApp/Db/BunchClkGen.db","P=xxx:")
#dbLoadRecords("$(VME)/vmeApp/Db/BunchClkGenA.db", "UNIT=xxx")
# hardware configuration
# example: BunchClkGenConfigure(intCard, unsigned long CardAddress)
#BunchClkGenConfigure(0, 0x8c00)

### GP307 Vacuum Controller
#dbLoadRecords("$(VME)/vmeApp/Db/gp307.db","P=xxx:")

# Machine Status Link (MSL) board (MRD 100)
#####################################################
# devAvmeMRDConfig( base, vector, level )
#    base   = base address of card
#    vector = interrupt vector
#    level  = interrupt level
# For Example
#    devAvmeMRDConfig(0xA0000200, 0xA0, 5)
#####################################################
#  Configure the MSL MRD 100 module.....
#devAvmeMRDConfig(0xB0000200, 0xA0, 5)    
#dbLoadRecords("$(VME)/vmeApp/Db/msl_mrd100.db","C=0,S=01,ID1=01,ID2=01us")

# Allen-Bradley 6008 scanner
#abConfigNlinks 1
#abConfigVme 0,0xc00000,0x60,5
#abConfigAuto

# APS quad electrometer
#<quadEM.cmd

# END vme.cmd -----------------------------------------------------------------
