# This configures the MPF server stuff

# slot a: IP-Octal (serial RS-232)
# slot b: EMPTY
# slot c: EMPTY
# slot d: EMPTY

# for IP modules on this board
localMessageRouterStart(0)

###############################################################################
# Initialize IP carrier
# ipacAddCarrier(ipac_carrier_t *pcarrier, char *cardParams)
#   pcarrier   - pointer to carrier driver structure
#   cardParams - carrier-specific init parameters

carrier = "ipac"
ipacAddCarrier(&ipmv162, "A:l=3,3 m=0xe0000000,64;B:l=3,3 m=0xe0010000,64;C:l=3,3 m=0xe0020000,64;D:l=3,3 m=0xe0030000,64")
initIpacCarrier(carrier, 0)

###############################################################################
# Initialize GPIB stuff

#initGpibGsTi9914("GS-IP488-0",carrier,"IP_b",104)
#initGpibServer("GPIB0","GS-IP488-0",1024,1000)

###############################################################################
# Initialize Octal UART stuff
initOctalUART("octalUart0",carrier,"IP_a",8,100)

# initOctalUARTPort(char* portName,char* moduleName,int port,int baud,
#                   char* parity,int stop_bits,int bits_char,char* flow_control)
# 'baud' is the baud rate. 1200, 2400, 4800, 9600, 19200, 38400
# 'parity' is "E" for even, "O" for odd, "N" for none.
# 'bits_per_character' = {5,6,7,8}
# 'stop_bits' = {1,2}
# 'flow_control' is "N" for none, "H" for hardware
#
# Don't leave any of these uninitialized, even if you aren't going to use them.

initOctalUARTPort("UART[0]","octalUart0",0, 9600,"N",2,8,"N") /* SRS570 */
initOctalUARTPort("UART[1]","octalUart0",1, 9600,"N",2,8,"N") /* SRS570 */
initOctalUARTPort("UART[2]","octalUart0",2, 9600,"N",2,8,"N") /* SRS570 */
initOctalUARTPort("UART[3]","octalUart0",3, 9600,"N",2,8,"N") /* SRS570 */
initOctalUARTPort("UART[4]","octalUart0",4, 9600,"N",2,8,"N") /* ? */
initOctalUARTPort("UART[5]","octalUart0",5, 9600,"N",2,8,"N") /* ? */
initOctalUARTPort("UART[6]","octalUart0",6, 9600,"N",2,8,"N") /* ? */
initOctalUARTPort("UART[7]","octalUart0",7, 9600,"N",1,8,"N") /* Keithley 2K */

initSerialServer("a-Serial[0]","UART[0]",1000,20,"\r",1)
initSerialServer("a-Serial[1]","UART[1]",1000,20,"\r",1)
initSerialServer("a-Serial[2]","UART[2]",1000,20,"\r",1)
initSerialServer("a-Serial[3]","UART[3]",1000,20,"\r",1)
initSerialServer("a-Serial[4]","UART[4]",1000,20,"\r",1)
initSerialServer("a-Serial[5]","UART[5]",1000,20,"\r",1)
initSerialServer("a-Serial[6]","UART[6]",1000,20,"\r",1)
initSerialServer("a-Serial[7]","UART[7]",1000,20,"\r",1)

###############################################################################
# Initialize Systran DAC
# initDAC128V(char *serverName, char *carrierName, char *siteName,
#             int queueSize)
# serverName  = name to give this server
# carrierName = name of IPAC carrier from initIpacCarrier above
# siteName    = name of IP site, e.g. "IP_a"
# queueSize   = size of output queue for EPICS
#

#initDAC128V("c-DAC",carrier,"IP_c",20)

###############################################################################
# Initialize Acromag ADC
# Ip330 *pIp330 = initIp330(
#    const char *moduleName, const char *carrierName, const char *siteName,
#    const char *typeString, const char *rangeString,
#    int firstChan, int lastChan,
#    int maxClients, int intVec)
#
# pIp330      = pointer to the Ip330 object, needed by configIp330(), and
#               needed to initialize the application-specific classes
# moduleName  = name to give this module
# carrierName = name of IPAC carrier from initIpacCarrier() above
# siteName    = name of IP site on the carrier, e.g. "IP_a"
# typeString  = "D" or "S" for differential or single-ended
# rangeString = "-5to5","-10to10","0to5", or "0to10"
#               This value must match hardware setting selected
# firstChan   = first channel to be digitized.  This must be in the range:
#               0 to 31 (single-ended)
#               0 to 15 (differential)
# lastChan    = last channel to be digitized
# maxClients  = Maximum number of Ip330 tasks which will attach to this
#               Ip330 module.  For example Ip330Scan, Ip330Sweep, etc.  This
#               does not refer to the number of EPICS clients.  A value of
#               10 should certainly be safe.
# intVec      = Interrupt vector

#pIp330 = initIp330("d-ADC", carrier, "IP_d", "D", "-10to10", 0, 15, 10, 205)

# int configIp330(Ip330 *pIp330, scanModeType scanMode,
#    const char *triggerString, int microSecondsPerScan,
#    int secondsBetweenCalibrate)
#
# pIp330      = pointer to the Ip330 object, returned by initIp330 above
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

#configIp330(pIp330, 3, "Input", 1000, 60)


# initIp330Scan(Ip330 *pIp330, char *serverName, int firstChan, int lastChan,
#               int milliSecondsToAverage, int queueSize)
# pIp330     = pointer returned by initIp330 above
# serverName = name to give this server
# firstChan  = first channel to be used by Ip330Scan.  This must be in the 
#              range firstChan to lastChan specified in initIp330
# lastChan   = last channel to be used by Ip330Scan.  This must be in the range
#              firstChan to lastChan specified in initIp330
# milliSecondsToAverage = number of milliseconds to average for values 
#              returned to EPICS
# queueSize  = size of output queue for EPICS

#initIp330Scan(pIp330,"d-Ip330Scan",0,15,100,20)


# initIp330Sweep(Ip330 *pIp330, char *serverName, int firstChan, int lastChan,
#                int maxPoints, int queueSize)
# pIp330     = pointer returned by initIp330 above
# serverName = name to give this server
# firstChan  = first channel to be used by Ip330Sweep.  This must be in the 
#              range firstChan to lastChan specified in initIp330
# lastChan   = last channel to be used by Ip330Sweep.  This must be in the 
#              range firstChan to lastChan specified in initIp330
# maxPoints  = maximum number of points in a sweep.  The amount of memory
#              allocated will be maxPoints*(lastChan-firstChan+1)*4 bytes
# queueSize  = size of output queue for EPICS

#initIp330Sweep(pIp330,"d-Ip330Sweep",0,12,2048,20)


# initIp330PID(char *serverName, Ip330 *pIp330, int ADCChan, 
#              DAC128V *pDAC128V, int DACChan,
#              double KP, double KI, double KD,
#              int interval, int feedbackOn, int lowLimit, int highLimit,
#              int queueSize)
# serverName = name to give this server
# pIp330     = pointer returned by initIp330 above
# ADCChan    = ADC channel to be used by Ip330PID.  This must be in the range
#              firstChan to lastChan specified in initIp330
# pDAC128V   = pointer returned by initDAC128V above
# DACChan    = DAC channel to be used by Ip330PID, in the range 0 to 7
# KP         = proportional gain, must be a floating point value
# KI         = integral gain, must be a floating point value
# KD         = derivative gain, must be a floating point value
# interval   = number of microseconds per feedback loop
# feedbackOn = initial state of feedback. 0 = off, 1 = on
# lowLimit   = lower limit on the DAC output, in the range 0-2047
# highLimit  = upper limit on the DAC output, in the range 0-2047
# queueSize  = size of output queue for EPICS

#pIp330PID = initIp330PID("Ip330PID_1", pIp330, 0, pDAC128V, 0, 20)
#configIp330PID(pIp330PID, .1, 10., 0., 1000, 0, 500, 1500)

###############################################################################
# Initialize Greenspring IP-Unidig

#initIpUnidig("b-Unidig", carrier, "IP_b", 20)

