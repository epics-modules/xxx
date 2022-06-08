# BEGIN canberra_3.cmd --------------------------------------------------------

#- AIMConfig(portName, ethernet_address, portNumber, maxChans,
#-           maxSignals, maxSequences, ethernetDevice)
#-    portName,         # asyn port name to be created
#-    ethernet_address, # Low order 16 bits of Ethernet hardware address
#-    portNumber,       # ADC port on AIM (1 or 2)
#-    maxChans,         # Maximum channels for this input
#-   maxSignals,       # Maximum signals for this input (>1 for MCS or multiplexor)
#-   maxSequences,     # Maximum sequences for time resolved applications
#-    ethernetDevice)   # Ethernet device name on IOC
#-                      # Typically ei0 for Motorola 68K, dc0 for ppc, fei0 for 5100, eth0 for Linux
AIMConfig("AIM1/1", 0xa78, 1, 2048, 1, 1, "ei0")
AIMConfig("AIM1/2", 0xa78, 2, 2048, 1, 1, "ei0")
AIMConfig("AIM2/1", 0xa79, 1, 2048, 1, 1, "ei0")

dbLoadRecords("$(MCA)/mcaApp/Db/3element.db","P=$(PREFIX)med:,BASENAME=mca,N=2000")
#- icbConfig(portName, ethernetAddress, icbAddress, moduleType)
#-    portName to give to this asyn port
#-    ethernetAddress - Ethernet address of module, low order 16 bits
#-    icbAddress - rotary switch setting inside ICB module
#-    moduleType
#-       0 = ADC
#-       1 = Amplifier
#-       2 = HVPS
#-       3 = TCA
#-       4 = DSP
# ADC's
icbConfig("icbAdc1", 0xa78, 3, 0)
icbConfig("icbAdc2", 0xa78, 4, 0)
icbConfig("icbAdc3", 0xa79, 5, 0)
#TCA's
icbConfig("icbTca1", 0xa78, 0, 3)
icbConfig("icbTca2", 0xa78, 1, 3)
icbConfig("icbTca3", 0xa78, 2, 3)


dbLoadTemplate("substitutions/canberra_3.substitutions")

# END canberra_3.cmd ----------------------------------------------------------
