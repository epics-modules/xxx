
# BEGIN canberra_13.cmd -------------------------------------------------------

#- AIMConfig(portName, ethernet_address, portNumber, maxChans,
#-           maxSignals, maxSequences, ethernetDevice)
#-    portName,         # asyn port name to be created
#-    ethernet_address, # Low order 16 bits of Ethernet hardware address
#-    portNumber,       # ADC port on AIM (1 or 2)
#-    maxChans,         # Maximum channels for this input
#-    maxSignals,       # Maximum signals for this input (>1 for MCS or multiplexor)
#-    maxSequences,     # Maximum sequences for time resolved applications
#-    ethernetDevice)   # Ethernet device name on IOC
#-                      # Typically ei0 for Motorola 68K, dc0 for ppc, eth0 for Linux
AIMConfig("AIM2/1", 0x98c, 1, 4000, 4, 1, "ei0")
AIMConfig("AIM2/2", 0x98d, 2, 4000, 4, 1, "ei0")
AIMConfig("AIM3/1", 0x98b, 1, 4000, 4, 1, "ei0")
AIMConfig("AIM3/2", 0x903, 2, 4000, 4, 1, "ei0")

dbLoadRecords("$(MCA)/mcaApp/Db/13element.db","P=$(PREFIX)med:")

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
# Amp's
icbConfig("icbAmp1", 0x98c, 1, 1)
icbConfig("icbAmp2", 0x98c, 2, 1)
icbConfig("icbAmp3", 0x98c, 3, 1)
icbConfig("icbAmp4", 0x98c, 4, 1)
icbConfig("icbAmp5", 0x98c, 5, 1)
icbConfig("icbAmp6", 0x98c, 6, 1)
icbConfig("icbAmp7", 0x98c, 8, 1)
icbConfig("icbAmp8", 0x98c, 9, 1)
icbConfig("icbAmp9", 0x98b, 1, 1)
icbConfig("icbAmp10", 0x98b, 2, 1)
icbConfig("icbAmp11", 0x98b, 3, 1)
icbConfig("icbAmp12", 0x98b, 4, 1)
icbConfig("icbAmp13", 0x98b, 5, 1)

# ADC's
icbConfig("icbAdc1", 0x98c, B, 0)
icbConfig("icbAdc2", 0x98c, 0, 0)
icbConfig("icbAdc2", 0x98b, B, 0)
icbConfig("icbAdc2", 0x98b, 7, 0)

#HVPS's
icbConfig("icbHvps1", 0x98b, A, 2)

dbLoadTemplate("substitutions/canberra_13.substitutions")

# END canberra_13.cmd ---------------------------------------------------------

