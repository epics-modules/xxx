# AIMConfig(serverName, int etherAddr, int port, int maxChans, 
#	int maxSignals, int maxSequences, etherDev, queueSize)
AIMConfig("AIM1/1", 0xa78, 1, 2048, 1, 1, "ei0", 100)
AIMConfig("AIM1/2", 0xa78, 2, 2048, 1, 1, "ei0", 100)
AIMConfig("AIM2/1", 0xa79, 1, 2048, 1, 1, "ei0", 100)

dbLoadRecords("mcaApp/Db/3element.db","P=xxx:med:,N=2000", mca)
dbLoadTemplate("3element.substitutions", mca)
