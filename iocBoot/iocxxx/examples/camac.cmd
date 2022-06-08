
# BEGIN camac.cmd -------------------------------------------------------------
#- Setup the ksc2917 hardware definitions
#- These are all actually the defaults, so this is not really necessary
#- num_cards, addrs, ivec, irq_level
ksc2917_setup(1, 0xFF00, 0x00A0, 2)

#- Initialize the CAMAC library.  Note that this is normally done automatically
#- in iocInit, but we need to get the CAMAC routines working before iocInit
#- because we need to initialize the DXP hardware.
camacLibInit

### E500 Motors
#- E500 driver setup parameters:
#-     (1) maximum # of controllers,
#-     (2) maximum # axis per card
#-     (3) motor task polling rate (min=1Hz, max=60Hz)
E500Setup(2, 8, 10)

#- E500 driver configuration parameters:
#-     (1) controller
#-     (2) branch
#-     (3) crate
#-     (4) slot
E500Config(0, 0, 0, 13)
E500Config(1, 0, 0, 14)

### Scalers: CAMAC scaler
#- CAMACScalerSetup(int max_cards)   /* maximum number of logical cards */
CAMACScalerSetup(1)

#- CAMACScalerConfig(int card,       /* logical card */
#-  int branch,                         /* CAMAC branch */
#-  int crate,                          /* CAMAC crate */
#-  int timer_type,                     /* 0=RTC-018 */
#-  int timer_slot,                     /* Timer N */
#-  int counter_type,                   /* 0=QS-450 */
#-  int counter_slot)                   /* Counter N */
CAMACScalerConfig(0, 0, 0, 0, 20, 0, 21)
dbLoadRecords("$(CAMAC)/camacApp/Db/CamacScaler.db","P=$(PREFIX),S=scaler1,C=0")
#dbLoadRecords("$(SCALER)/db/scaler.db","P=$(PREFIX),S=scaler1,C=0,DTYP=CAMAC scaler,FREQ=10000000")

# Generic CAMAC record
dbLoadRecords("$(CAMAC)/camacApp/Db/generic_camac.db","P=$(PREFIX),R=camac1,SIZE=2048")

# END camac.cmd ---------------------------------------------------------------
