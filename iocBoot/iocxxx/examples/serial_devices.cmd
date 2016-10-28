#ACS MCB-4B
#iocshLoad("$(MOTOR)/iocsh/ACS_MCB4B.iocsh", "PORT=serial3, CONTROLLER=0, POLL_RATE=100, NUM_AXES=1")

# Eurotherm temp controller
#dbLoadRecords("$(IP)/ipApp/Db/Eurotherm.db","P=$(PREFIX),PORT=serial7")

# Heidenhain ND261 encoder (for PSL monochromator)
#iocshLoad("$(IP)/iocsh/Heidenhain_ND261.iocsh", "PREFIX=$(PREFIX), PORT=serial1")

# Huber DMC9200 DC Motor Controller
#dbLoadRecords("$(IP)/ipApp/Db/HuberDMC9200.db", "P=$(PREFIX),Q=DMC1:,PORT=serial5")

# Keithley 2000 DMM
#iocshLoad("$(IP)/iocsh/Keithley_2k_serial.iocsh", "PREFIX=$(PREFIX), INSTANCE=D1, PORT=serial0, NUM_CHANNELS=22, MODEL=2700")
#iocshLoad("$(IP)/iocsh/Keithley_2k_serial.iocsh", "PREFIX=$(PREFIX), INSTANCE=D1, PORT=serial0, NUM_CHANNELS=10, MODEL=2000")

# Lakeshore DRC-93CA Temperature Controller
#iocshLoad("$(IP)/iocsh/Lakeshore_DRC93CA.iocsh", "PREFIX=$(PREFIX), INSTANCE=TC1, PORT=serial4")

#McClennan PM304
#iocshLoad("$(MOTOR)/iocsh/McClennan_PM304.iocsh", "PORT=serial4, CONTROLLER=0, POLL_RATE=10, MAX_CONTROLLERS=1, NUM_AXES=1")

# MKS vacuum gauges
#dbLoadRecords("$(IP)/ipApp/Db/MKS.db","P=$(PREFIX),PORT=serial2,CC1=cc1,CC2=cc3,PR1=pr1,PR2=pr3")

#Newport MM4000
#iocshLoad("$(MOTOR)/iocsh/Newport_MM4000.iocsh", "PORT=serial2, CONTROLLER=0, POLL_RATE=10, MAX_CONTROLLERS=1")

#Newport PM500
#iocshLoad("$(MOTOR)/iocsh/Newport_PM500.iocsh",  "PORT=serial3, CONTROLLER=0, POLL_RATE=10, MAX_CONTROLLERS=1")

# Oriel 18011 Encoder Mike
#dbLoadRecords("$(IP)/ipApp/Db/eMike.db", "P=$(PREFIX),M=em1,PORT=serial3")

# Oxford Cyberstar X1000 Scintillation detector and pulse processing unit
#iocshLoad("$(IP)/iocsh/Oxford_X1k.iocsh", "PREFIX=$(PREFIX), INSTANCE=s1, PORT=serial4")

# Oxford ILM202 Cryogen Level Meter (Serial)
#iocshLoad("$(IP)/iocsh/Oxford_ILM202.iocsh", "PREFIX=$(PREFIX), INSTANCE=s1, PORT=serial5")

# PI Digitel 500/1500 pump
#dbLoadRecords("$(IP)/ipApp/Db/Digitel.db","$(PREFIX),PUMP=ip1,PORT=serial3")

# PI MPC ion pump
#dbLoadRecords("$(IP)/ipApp/Db/MPC.db","P=$(PREFIX),PUMP=ip2,PORT=serial4,PA=0,PN=1")

# PI MPC TSP (titanium sublimation pump)
#dbLoadRecords("$(IP)/ipApp/Db/TSP.db","P=$(PREFIX),TSP=tsp1,PORT=serial4,PA=0")

### Queensgate piezo driver
#iocshLoad("$(IP)/iocsh/Queensgate_piezo.iocsh", "P=$(PREFIX), PORT=serial5")

# Stanford Research Systems SR570 Current Preamplifier
#iocshLoad("$(IP)/iocsh/SR_570.iocsh", "PREFIX=$(PREFIX), INSTANCE=A1, PORT=serial1")
