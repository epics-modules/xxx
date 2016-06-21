### Stuff for user programming ###
dbLoadRecords("$(CALC)/calcApp/Db/userCalcGlobalEnable.db","P=$(PREFIX)")

dbLoadRecords("$(CALC)/calcApp/Db/userCalcs10.db","P=$(PREFIX)")
appendToFile("$(BUILT_SETTINGS)", '$(P)userCalcEnable')

dbLoadRecords("$(CALC)/calcApp/Db/userCalcOuts10.db","P=$(PREFIX)")
appendToFile("$(BUILT_SETTINGS)", '$(P)userCalcOutEnable')

dbLoadRecords("$(CALC)/calcApp/Db/userCalcOuts10more.db","P=$(PREFIX),N1=11,N2=12,N3=13,N4=14,N5=15,N6=16,N7=17,N8=18,N9=19,N10=20")

dbLoadRecords("$(CALC)/calcApp/Db/userStringCalcs10.db","P=$(PREFIX)")
appendToFile("$(BUILT_SETTINGS)", '$(P)userStringCalcEnable')

dbLoadRecords("$(CALC)/calcApp/Db/userArrayCalcs10.db","P=$(PREFIX),N=8000")
appendToFile("$(BUILT_SETTINGS)", '$(P)userArrayCalcEnable')

dbLoadRecords("$(CALC)/calcApp/Db/userTransforms10.db","P=$(PREFIX)")
appendToFile("$(BUILT_SETTINGS)", '$(P)userTranEnable')

dbLoadRecords("$(CALC)/calcApp/Db/userAve10.db","P=$(PREFIX)")
appendToFile("$(BUILT_SETTINGS)", "$(P)userAveEnable")

# string sequence (sseq) records
dbLoadRecords("$(CALC)/calcApp/Db/userStringSeqs10.db","P=$(PREFIX)")
appendToFile("$(BUILT_SETTINGS)", '$(P)userStringSeqEnable')

# editSseq - edit any sseq or seq record
dbLoadRecords("$(CALC)/calcApp/Db/editSseq.db", "P=$(PREFIX),Q=ES:")
doAfterIocInit("seq &editSseq, 'P=$(PREFIX),Q=ES:'")

# interpolation
dbLoadRecords("$(CALC)/calcApp/Db/interp.db", "P=$(PREFIX),N=2000")
dbLoadRecords("$(CALC)/calcApp/Db/interpNew.db", "P=$(PREFIX),Q=1,N=2000")

# busy record
dbLoadRecords("$(BUSY)/busyApp/Db/busyRecord.db", "P=$(PREFIX),R=mybusy1")
dbLoadRecords("$(BUSY)/busyApp/Db/busyRecord.db", "P=$(PREFIX),R=mybusy2")

# Soft function generator
#dbLoadRecords("$(CALC)/calcApp/Db/FuncGen.db","P=$(PREFIX),Q=fgen,OUT=$(PREFIX)m7.VAL")

