# This configures the MPF server stuff

# First carrier
# slot a: IP-Octal (serial RS-232)
# slot b: IpUnidig (digital I/O)
# slot c: Ip330 (A/D converter)
# slot d: Dac128V (D/A converter)

###############################################################################
# Initialize IP carrier
# ipacAddCarrier(ipac_carrier_t *pcarrier, char *cardParams)
#   pcarrier   - pointer to carrier driver structure
#   cardParams - carrier-specific init parameters

# Select for MVME162 or MVME172 CPU board IP carrier.
#carrier1=ipacAddMVME162("A:l=3,3 m=0xe0000000,64;B:l=3,3 m=0xe0010000,64;C:l=3,3 m=0xe0020000,64;D:l=3,3 m=0xe0030000,64")

# Select for SBS VIPC616-01 version IP carrier.
carrier1=ipacAddVIPC616_01("0x3000,0xa0000000")

###############################################################################
# Initialize Octal UART stuff
tyGSOctalDrv 1
tyGSOctalModuleInit("GSIP_OCTAL232", 0x80, 0, 0)

# int tyGSMPFInit(char *server, int uart, int channel, int baud, char parity, int sbits,
#                 int dbits, char handshake, char *eomstr)
tyGSMPFInit("serial1",  0, 0, 9600,'N',2,8,'N',"")  /* SRS570 */
tyGSMPFInit("serial2",  0, 1,19200,'E',1,8,'N',"")  /* MKS */
tyGSMPFInit("serial3",  0, 2, 9600,'E',1,7,'N',"")  /* Digitel */
tyGSMPFInit("serial4",  0, 3, 9600,'N',1,8,'N',"")  /* MPC */
tyGSMPFInit("serial5",  0, 4, 9600,'E',1,7,'N',"")  /* McClennan PM304 */
tyGSMPFInit("serial6",  0, 5,19200,'N',1,8,'N',"")  /* Keithley 2000 */
tyGSMPFInit("serial7",  0, 6, 9600,'N',1,8,'N',"")  /* Oxford ILM cryometer */
tyGSMPFInit("serial8",  0, 7,19200,'N',1,8,'N',"")  /* Love controllers */

# Initialize Greenspring IP-Unidig
# initIpUnidig(char *serverName,
#              int carrier,
#              int slot,
#              int queueSize,
#              int msecPoll,
#              int intVec,
#              int risingMask,
#              int fallingMask,
#              int biMask,
#              int maxClients)
# serverName  = name to give this server
# carrier     = IPAC carrier number (0, 1, etc.)
# slot        = IPAC slot (0,1,2,3, etc.)
# queueSize   = size of output queue for EPICS
# msecPoll    = polling time for input bits in msec.  Default=100.
# intVec      = interrupt vector
# risingMask  = mask of bits to generate interrupts on low to high (24 bits)
# fallingMask = mask of bits to generate interrupts on high to low (24 bits)
# biMask      = mask of bits to generate callbacks to bi record support
#               This can be a subset of (risingMask | fallingMask)
# maxClients  = Maximum number of callback tasks which will attach to this
#               IpUnidig server.  This
#               does not refer to the number of EPICS clients.  A value of
#               10 should certainly be safe.
initIpUnidig("Unidig1", 0, 1, 20, 2000, 116, 1, 1, 0xffff, 10)

# Initialize Acromag IP-330 ADC
# initIp330(
#   const char *moduleName, int carrier, int slot,
#   const char *typeString, const char *rangeString,
#   int firstChan, int lastChan,
#   int maxClients, int intVec)
# moduleName  = name to give this module
# carrier     = IPAC carrier number (0, 1, etc.)
# slot        = IPAC slot (0,1,2,3, etc.)
# typeString  = "D" or "S" for differential or single-ended
# rangeString = "-5to5","-10to10","0to5", or "0to10"
#               This value must match hardware setting selected
# firstChan   = first channel to be digitized.  This must be in the range:
#               0 to 31 (single-ended)
#               0 to 15 (differential)
# lastChan    = last channel to be digitized
# maxClients =  Maximum number of Ip330 tasks which will attach to this
#               Ip330 module.  For example Ip330Scan, Ip330Sweep, etc.  This
#               does not refer to the number of EPICS clients.  A value of
#               10 should certainly be safe.
# intVec        Interrupt vector
initIp330("Ip330_1",0,2,"D","-5to5",0,15,10,120)

# configIp330(
#   const char *moduleName,
#   int scanMode, const char *triggerString,
#   int microSecondsPerScan, int secondsBetweenCalibrate)
# moduleName  = name of module passed to initIp330 above
# scanMode    = scan mode:
#               0 = disable
#               1 = uniformContinuous
#               2 = uniformSingle
#               3 = burstContinuous (normally recommended)
#               4 = burstSingle
#               5 = convertOnExternalTriggerOnly
# triggerString = "Input" or "Output". Selects the direction of the external
#               trigger signal.
# microSecondsPerScan = repeat interval to digitize all channels
#               The minimum theoretical time is 15 microseconds times the
#               number of channels, but a practical limit is probably 100
#               microseconds.
# secondsBetweenCalibrate = number of seconds between calibration cycles.
#               If zero then there will be no periodic calibration, but
#               one calibration will still be done at initialization.
configIp330("Ip330_1", 3,"Input",500,0)

# initIp330Scan(
#      const char moduleName, const char *serverName, int firstChan, int lastChan,
#      int queueSize)
# moduleName = module name passed to initIp330 above
# serverName = name to give this server.  Must match the INP parm field in
#              EPICS records
# firstChan  = first channel to be used by Ip330Scan.  This must be in the
#              range firstChan to lastChan specified in initIp330
# lastChan   = last channel to be used by Ip330Scan.  This must be in the range
#              firstChan to lastChan specified in initIp330
# queueSize  = size of output queue for MPF. Make this the maximum number
#              of ai records attached to this server.
initIp330Scan("Ip330_1","Ip330Scan1",0,15,100)

# initIp330Sweep(char *moduleName, char *serverName, int firstChan,
#     int lastChan, int maxPoints, int queueSize)
# moduleName = module name passed to initIp330 above
# serverName = name to give this server
# firstChan  = first channel to be used by Ip330Sweep.  This must be in the
#              range firstChan to lastChan specified in initIp330
# lastChan   = last channel to be used by Ip330Sweep.  This must be in the
#              range firstChan to lastChan specified in initIp330
# maxPoints  = maximum number of points in a sweep.  The amount of memory
#              allocated will be maxPoints*(lastChan-firstChan+1)*4 bytes
# queueSize  = size of output queue for EPICS
initIp330Sweep("Ip330_1","Ip330Sweep1",0,3,2048,100)

# initIp330PID(const char *serverName,
#        char *ip330Name, int ADCChannel, dacName, int DACChannel,
#        int queueSize)
# serverName = name to give this server
# ip330Name  = module name passed to initIp330 above
# ADCChannel = ADC channel to be used by Ip330PID as its readback source.
#              This must be in the range firstChan to lastChan specified in
#              initIp330
# dacName    = server name passed to initDAC128V
# DACChannel = DAC channel to be used by Ip330PID as its control output.  This
#              must be in the range 0-7.
# queueSize  = size of output queue for EPICS
initIp330PID("Ip330PID1", "Ip330_1", 0, "DAC1", 0, 20)

# Initialize Systran DAC
# initDAC128V(char *serverName, int carrier, int slot, int queueSize)
# serverName  = name to give this server
# carrier     = IPAC carrier number (0, 1, etc.)
# slot        = IPAC slot (0,1,2,3, etc.)
# queueSize   = size of output queue for EPICS
#
initDAC128V("DAC1", 0, 3, 20)

