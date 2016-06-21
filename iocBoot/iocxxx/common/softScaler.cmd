# soft scaler
dbLoadRecords("$(ASYN)/db/asynRecord.db","P=$(PREFIX),R=asynScaler,PORT=scaler1Port,ADDR=0,OMAX=0,IMAX=0")
# drvScalerSoftConfigure(char *portName, int maxChans, char *pvTemplate)
drvScalerSoftConfigure("scaler1Port", 8, "$(PREFIX)scaler1:s%d")
dbLoadRecords("$(STD)/stdApp/Db/scaler.db","P=$(PREFIX),S=scaler1,OUT=@asyn(scaler1Port 0 0),DTYP=Asyn Scaler,FREQ=10000000")
dbLoadRecords("$(STD)/stdApp/Db/scalerSoftCtrl.db","P=$(PREFIX),Q=scaler1:,SCALER=$(PREFIX)scaler1")
