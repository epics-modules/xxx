# BEGIN canberra_3.cmd --------------------------------------------------------

# AIMConfig(serverName, int etherAddr, int port, int maxChans, 
#	int maxSignals, int maxSequences, etherDev, queueSize)
AIMConfig("AIM1/1", 0xa78, 1, 2048, 1, 1, "ei0", 100)
AIMConfig("AIM1/2", 0xa78, 2, 2048, 1, 1, "ei0", 100)
AIMConfig("AIM2/1", 0xa79, 1, 2048, 1, 1, "ei0", 100)

dbLoadRecords("$(MCA)/mcaApp/Db/3element.db","P=xxx:med:,N=2000")

# icbConfig(portName, ethernetAddress, icbAddress, moduleType)
#    portName to give to this asyn port
#    ethernetAddress - Ethernet address of module, low order 16 bits
#    icbAddress - rotary switch setting inside ICB module
#    moduleType
#       0 = ADC
#       1 = Amplifier
#       2 = HVPS
#       3 = TCA
#       4 = DSP
# ADC's
icbConfig("icbAdc1", 0xa78, 3, 0)
icbConfig("icbAdc2", 0xa78, 4, 0)
icbConfig("icbAdc3", 0xa79, 5, 0)
#TCA's
icbConfig("icbTca1", 0xa78, 0, 3)
icbConfig("icbTca2", 0xa78, 1, 3)
icbConfig("icbTca3", 0xa78, 2, 3)


dbLoadTemplate("3element.substitutions")

# END canberra_3.cmd ----------------------------------------------------------
