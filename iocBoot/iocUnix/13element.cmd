# AIMConfig(serverName, int etherAddr, int port, int maxChans, 
#	int maxSignals, int maxSequences, etherDev, queueSize)
AIMConfig("AIM2/1", 0x98c, 1, 4000, 4, 1, "eth0", 100)
AIMConfig("AIM2/2", 0x98d, 2, 4000, 4, 1, "eth0", 100)
AIMConfig("AIM3/1", 0x98b, 1, 4000, 4, 1, "eth0", 100)
AIMConfig("AIM3/2", 0x903, 2, 4000, 4, 1, "eth0", 100)

dbLoadRecords("$(MCA)/mcaApp/Db/13element.db","P=xxx:med:,N=2000")
dbLoadTemplate("13element.substitutions")
