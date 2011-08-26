# Attempt at support for an Omega CN740 temperature controller.


drvAsynSerialPortConfigure("serial1", "serial1", 0, 0, 0)
asynSetOption("serial1",0,"baud","9600")
asynSetOption("serial1",0,"parity","even")
asynSetOption("serial1",0,"bits","7")
asynSetOption("serial1",0,"stop","1")
asynOctetSetOutputEos("serial1",0,"\r\n")
asynOctetSetInputEos("serial1",0,"\r\n")

#modbusInterposeConfig(portName, linkType, timeoutMsec, writeDelayMsec)
# linkType 2 is "ASCII serial"
modbusInterposeConfig("serial1", 2, 1000, 0)


#drvModbusAsynConfigure(portName, tcpPortName, slaveAddress, modbusFunction, 
#	modbusStartAddress, modbusLength, dataType, pollMsec, plcType);

drvModbusAsynConfigure("myModbusPort, "serial1", 1, modbusFunction, 
	modbusStartAddress, modbusLength, dataType, pollMsec, plcType);
