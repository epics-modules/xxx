
# BEGIN quadEM.cmd ------------------------------------------------------------

#- initQuadEM(quadEMName, baseAddress, fiberChannel, microSecondsPerScan,
#-            maxClients, unidigName, unidigChan)
#-  quadEMName  = name of quadEM object created
#-  baseAddress = base address of VME card
#-  channel     = 0-3, fiber channel number
#-  microSecondsPerScan = microseconds to integrate.  When used with ipUnidig
#-                interrupts the unit is also read at this rate.
#-  unidigName  = name of ipInidig server if it is used for interrupts.
#-                Set to 0 if there is no IP-Unidig being used, in which
#-                case the quadEM will be read at 60Hz.
#-  unidigChan  = IP-Unidig channel connected to quadEM pulse output
initQuadEM("quadEM1", 0xf000, 0, 1000, "Unidig1", 2)
initQuadEM("quadEM2", 0xf000, 1, 1000, "Unidig1", 2)
initQuadEM("quadEM3", 0xf000, 2, 1000, "Unidig1", 2)
initQuadEM("quadEM4", 0xf000, 3, 1000, "Unidig1", 2)
#- Use the following if an IpUnidig is not being used for interrupts
#- It will use 60Hz system clock instead
#initQuadEM("quadEM1", 0xf000, 0, 1000, 0, 0)
#initQuadEM("quadEM2", 0xf000, 1, 1000, 0, 0)
#initQuadEM("quadEM3", 0xf000, 2, 1000, 0, 0)
#initQuadEM("quadEM4", 0xf000, 3, 1000, 0, 0)

#- initFastSweep(portName, inputName, maxSignals, maxPoints)
#-  portName = asyn port name for this new port (string)
#-  inputName = name of asynPort providing data
#-  maxSignals  = maximum number of signals (spectra)
#-  maxPoints  = maximum number of channels per spectrum
initFastSweep("quadEMSweep", "quadEM1", 10, 2048)

# Databases for ai records that give average readings of current, positions, etc.
dbLoadRecords("$(QUADEM)/quadEMApp/Db/quadEM.db", "P=$(PREFIX), EM=EM1, PORT=quadEM1")
dbLoadRecords("$(QUADEM)/quadEMApp/Db/quadEM.db", "P=$(PREFIX), EM=EM2, PORT=quadEM2")
dbLoadRecords("$(QUADEM)/quadEMApp/Db/quadEM.db", "P=$(PREFIX), EM=EM3, PORT=quadEM3")
dbLoadRecords("$(QUADEM)/quadEMApp/Db/quadEM.db", "P=$(PREFIX), EM=EM4, PORT=quadEM4")

# Database for FastSweep (mca records), i.e. quadEM digital scope
dbLoadRecords("$(QUADEM)/quadEMApp/Db/quadEM_med.db", "P=$(PREFIX)quadEM:,NCHAN=2048,PORT=quadEMSweep")
dbLoadRecords("$(QUADEM)/quadEMApp/Db/quadEM_med_FFT.db", "P=$(PREFIX)quadEM_FFT:,NCHAN=1024")

# Database for fast feedback using quadEM and dac128V
dbLoadTemplate("substitutions/quadEM_pid.substitutions", "P=$(PREFIX)")

# END quadEM.cmd --------------------------------------------------------------
