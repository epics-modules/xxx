
# BEGIN serial.cmd ------------------------------------------------------------

#Creates serial0 through serial7
iocshLoad("$(IPAC)/iocsh/tyGSOctal.iocsh", "INSTANCE=UART_0, PORT=serial, TYPE=232, CARRIER=0, SLOT=0, INT_VEC=0x80, MAX_MODULES=1")
iocshLoad("$(IP)/iocsh/loadSerialComm.iocsh", "PREFIX=$(PREFIX), PORT=serial")

#Creates serial10 through serial17
#iocshLoad("$(IPAC)/iocsh/tyGSOctal.iocsh", "INSTANCE=UART_1, PORT=serial1, TYPE=232, CARRIER=0, SLOT=1, INT_VEC=0x80")
#iocshLoad("$(IP)/iocsh/loadSerialComm.iocsh", "PREFIX=$(PREFIX), PORT=serial1")

#serial0 - SR570
#serial1 - 
#serial2 - Newport PM500
#serial3 - 
#serial4 - ACS MCB-4B
#serial5 - 
#serial6 - Newport MM4000
#serial7 - Love Controllers


#iocshLoad("$(MOTOR)/iocsh/Newport_MM4000.iocsh",  "PORT=serial6, CONTROLLER=0, POLL_RATE=10, MAX_CONTROLLERS=1")
#iocshLoad("$(MOTOR)/iocsh/Newport_PM500.iocsh",   "PORT=serial2, CONTROLLER=0, POLL_RATE=10, MAX_CONTROLLERS=1")
#iocshLoad("$(MOTOR)/iocsh/McClennan_PM304.iocsh", "PORT=serial3, CONTROLLER=0, POLL_RATE=10,  NUM_AXES=1, MAX_CONTROLLER=1")
#iocshLoad("$(MOTOR)/iocsh/ACS_MCB4B.iocsh",       "PORT=serial4, CONTROLLER=0, POLL_RATE=100, NUM_AXES=1")

# Stanford Research Systems SR570 Current Preamplifier
#iocshLoad("$(IP)/iocsh/SR_570.iocsh", "PREFIX=$(PREFIX), INSTANCE=A1, PORT=serial0")

# Keithley 2000 DMM
#iocshLoad("$(IP)/iocsh/Keithley_2k_serial.iocsh", "PREFIX=$(PREFIX), INSTANCE=D1, PORT=serial0, NUM_CHANNELS=22, MODEL=2700")
#iocshLoad("$(IP)/iocsh/Keithley_2k_serial.iocsh", "PREFIX=$(PREFIX), INSTANCE=D1, PORT=serial0, NUM_CHANNELS=10, MODEL=2000")

# Oxford Cyberstar X1000 Scintillation detector and pulse processing unit
#iocshLoad("$(IP)/iocsh/Oxford_X1k.iocsh", "PREFIX=$(PREFIX), INSTANCE=s1, PORT=serial3")

# Oxford ILM202 Cryogen Level Meter (Serial)
#iocshLoad("$(IP)/iocsh/Oxford_ILM202.iocsh", "PREFIX=$(PREFIX), INSTANCE=s1, PORT=serial4")

# END serial.cmd --------------------------------------------------------------
