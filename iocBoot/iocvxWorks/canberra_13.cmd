# AIMConfig(portName, ethernet_address, portNumber, maxChans,
#           maxSignals, maxSequences, ethernetDevice)
#    portName,         # asyn port name to be created
#    ethernet_address, # Low order 16 bits of Ethernet hardware address
#    portNumber,       # ADC port on AIM (1 or 2)
#    maxChans,         # Maximum channels for this input
#    maxSignals,       # Maximum signals for this input (>1 for MCS or multiplexor)
#    maxSequences,     # Maximum sequences for time resolved applications
#    ethernetDevice)   # Ethernet device name on IOC
#                      # Typically ei0 for Motorola 68K, dc0 for ppc, eth0 for Linux
AIMConfig("AIM2/1", 0x98c, 1, 4000, 4, 1, "ei0")
AIMConfig("AIM2/2", 0x98d, 2, 4000, 4, 1, "ei0")
AIMConfig("AIM3/1", 0x98b, 1, 4000, 4, 1, "ei0")
AIMConfig("AIM3/2", 0x903, 2, 4000, 4, 1, "ei0")

dbLoadRecords("$(MCA)/mcaApp/Db/13element.db","P=xxx:med:")
dbLoadTemplate("canberra_13Element.substitutions")
