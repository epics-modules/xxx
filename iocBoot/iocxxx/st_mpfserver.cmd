# This configures the MPF server stuff for the processor that runs st.cmd

# First carrier
# slot a: IP-Octal (serial RS-232)
# slot b: IP-488 (GPIB)
# slot c: Dac128V (D/A converter)
# slot d: Ip330 (A/D converter)

# Second carrier
# slot a: IpUnidig (digital I/O)
# slot b: IP-Octal (serial RS-232)

###############################################################################
# Initialize IP carrier
# ipacAddCarrier(ipac_carrier_t *pcarrier, char *cardParams)
#   pcarrier   - pointer to carrier driver structure
#   cardParams - carrier-specific init parameters

# Select for MVME162 or MVME172 CPU board IP carrier.
carrier1 = "mv162"
ipacAddCarrier(&ipmv162, "A:l=3,3 m=0xe0000000,64;B:l=3,3 m=0xe0010000,64;C:l=3,3 m=0xe0020000,64;D:l=3,3 m=0xe0030000,64")

# For SBS VIPC616-01 IP carrier board.  A32 and A24 examples follow:
#carrier1 = "VIPC616_01"

# - A32 addressing.
# - default I/O Base Address (0x6000).
# - IP modules occupy 32MB of memory from 0x9000 0000 to 0x91FF FFFF.
# - IP module A at 0x90000000,
#      module B at 0x90800000,
#      module C at 0x91000000,
#      module D at 0x91800000
#ipacAddCarrier(&vipc616_01,"6000,90000000")

# - A24 addressing.
# - default I/O Base Address (0x6000).
# - default IP module base address at 0x00D0 0000
#   occupies 512 bytes of memory from 0x00D0 0000 to 0x00D0 01FF.
# - IP module A at 0x0x00D0 007F,
#      module B at 0x0x00D0 0100,
#      module C at 0x0x00D0 017F,
#      module D at 0x0x00D0 01FF
#ipacAddCarrier(&vipc616_01, "0x6000,D00000,128")

#carrier2 = "VIPC616_02"
#ipacAddCarrier(&vipc616_01, "0x3400,D00000,128")

initIpacCarrier(carrier1, 0)
#initIpacCarrier(carrier2, 0)

###############################################################################
# Initialize GPIB stuff

#initGpibGsTi9914("GS-IP488-0",carrier1,"IP_b",104)
#initGpibServer("GPIB0","GS-IP488-0",1024,1000)

###############################################################################
# Initialize Octal UART stuff
initOctalUART("octalUart0",carrier1,"IP_a",8,100)
#initOctalUART("octalUart1",carrier2,"IP_b",8,100)

# initOctalUARTPort(char* portName,char* moduleName,int port,int baud,
#                   char* parity,int stop_bits,int bits_char,char* flow_control)
# 'baud' is the baud rate. 1200, 2400, 4800, 9600, 19200, 38400
# 'parity' is "E" for even, "O" for odd, "N" for none.
# 'bits_per_character' = {5,6,7,8}
# 'stop_bits' = {1,2}
# 'flow_control' is "N" for none, "H" for hardware
#
# Don't leave any of these uninitialized, even if you aren't going to use them.

initOctalUARTPort("UART[0]","octalUart0",0, 9600,"N",2,8,"N")  /* SRS570 */
initOctalUARTPort("UART[1]","octalUart0",1,19200,"E",1,8,"N")  /* MKS */
initOctalUARTPort("UART[2]","octalUart0",2, 9600,"E",1,7,"N")  /* Digitel */
initOctalUARTPort("UART[3]","octalUart0",3, 9600,"N",1,8,"N")  /* MPC */
initOctalUARTPort("UART[4]","octalUart0",4, 9600,"E",1,7,"N")  /* McClennan PM304 */
initOctalUARTPort("UART[5]","octalUart0",5,19200,"N",1,8,"N")  /* Keithley 2000 */
initOctalUARTPort("UART[6]","octalUart0",6, 9600,"N",1,8,"N")  /* Oxford ILM cryometer */
initOctalUARTPort("UART[7]","octalUart0",7,19200,"N",1,8,"N")  /* Love controllers */
# Second IP-Octal
initOctalUARTPort("UART[8]", "octalUart1",0,38400,"N",1,8,"N")  /* MM4000 */
initOctalUARTPort("UART[9]", "octalUart1",1, 9600,"N",1,8,"N")  /* ? */
initOctalUARTPort("UART[10]","octalUart1",2, 9600,"N",1,8,"N")  /* ? */
initOctalUARTPort("UART[11]","octalUart1",3, 9600,"N",1,8,"N")  /* ? */
initOctalUARTPort("UART[12]","octalUart1",4, 9600,"N",1,8,"N")  /* ? */
initOctalUARTPort("UART[13]","octalUart1",5, 9600,"N",1,8,"N")  /* ? */
initOctalUARTPort("UART[14]","octalUart1",6, 9600,"N",1,8,"N")  /* ? */
initOctalUARTPort("UART[15]","octalUart1",7, 9600,"N",1,8,"N")  /* ? */

#################################################################
# settings for various other devices
# Heidenhain ND261
#initOctalUARTPort("UART[0]","octalUart0", 0, 9600,"E",2,7,"N")
#
# Oriel 18011 encoder mike controller
#initOctalUARTPort("UART[0]","octalUart0", 0, 4800,"N",1,8,"N")
#
# Lakeshore temperature controller
#initOctalUARTPort("UART[0]","octalUart0", 0, 1200,"N",1,7,"N")
#
# Moller-Wedel AutoCollimator
#initOctalUARTPort("UART[0]","octalUart0", 0, 2400,"N",1,8,"N")
#
# Eurotherm
#initOctalUARTPort("UART[0]","octalUart0", 0, 9600,"E",1,7,"N")
#
# Oxford Cyberstar X1000
#initOctalUARTPort("UART[0]","octalUart0", 0, 9600,"N",1,8,"N")
#
# Huber DMC9200
#initOctalUARTPort("UART[0]","octalUart0", 0, 9600,"N",1,8,"N")
#
# PI 500 Series piezo controller
#initOctalUARTPort("UART[0]","octalUart0", 0, 9600,"N",1,8,"N")
#
# Oxford ILM202 Cryogen Level Meter
#initOctalUARTPort("UART[0]","octalUart0", 0, 9600,"N",1,8,"N")
#
# Lakeshore 819 cryopump monitor
#initOctalUARTPort("UART[0]","octalUart0", 0, 300,"O",1,7,"N")
#
# OMEGA DP41 Temperature Controller
#initOctalUARTPort("UART[0]","octalUart0", 0, 9600,"O",1,7,"N")
#################################################################

initSerialServer("a-Serial[0]","UART[0]",1000,20,"\r",1)
initSerialServer("a-Serial[1]","UART[1]",1000,20,"\r",1)
initSerialServer("a-Serial[2]","UART[2]",1000,20,"\r",1)
# Comment out the following line if using the MPC, it needs a special sever
#initSerialServer("a-Serial[3]","UART[3]",1000,20,"\r",1)
# a-Serial[3] uses the MPC server and needs a larger queue
initMPCServer("a-Serial[3]","UART[3]",60)
initSerialServer("a-Serial[4]","UART[4]",1000,20,"\r",1)
initSerialServer("a-Serial[5]","UART[5]",1000,20,"\r",1)
initSerialServer("a-Serial[6]","UART[6]",1000,20,"\r",1)
# Comment out the following line if using the love controller
initSerialServer("a-Serial[7]","UART[7]",1000,20,"\r",1)
#initLoveServer("PORT7","UART[7]",112)

initSerialServer("b-Serial[0]","UART[8]",1000,20,"\r",1)
initSerialServer("b-Serial[1]","UART[9]",1000,20,"\r",1)
initSerialServer("b-Serial[2]","UART[10]",1000,20,"\r",1)
initSerialServer("b-Serial[3]","UART[11]",1000,20,"\r",1)
initSerialServer("b-Serial[4]","UART[12]",1000,20,"\r",1)
initSerialServer("b-Serial[5]","UART[13]",1000,20,"\r",1)
initSerialServer("b-Serial[6]","UART[14]",1000,20,"\r",1)
initSerialServer("b-Serial[7]","UART[15]",1000,20,"\r",1)

#
# Initialize Systran DAC
# pDAC128V = initDAC128V(char *serverName, char *carrierName, char *siteName,
#             int queueSize)
# pDAC128V    = pointer to MPF server, used for fast feedback
# serverName  = name to give this server
# carrierName = name of IPAC carrier from initIpacCarrier above
# siteName    = name of IP site, e.g. "IP_a"
# queueSize   = size of output queue for EPICS
#
#pDAC128V = initDAC128V("c-DAC",carrier1,"IP_c",20)

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

#pIp330 = initIp330("d-ADC", carrier1, "IP_d", "D", "-10to10", 0, 15, 10, 205)

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

#initIp330Sweep(pIp330,"d-Ip330Sweep",0,12,2048,200)

#       Ip330 *pIp330, int ADCChannel, DAC128V *pDAC128V, int DACChannel,
#        int queueSize)
# serverName = name to give this server
# pIp330     = pointer returned by initIp330 above
# ADCChannel = ADC channel to be used by Ip330PID as its readback source.
#              This must be in the range firstChan to lastChan specified in
#              initIp330
# pDAC128V   = pointer returned by initDAC128V
# DACChannel = DAC channel to be used by Ip330PID as its control output.  This
#              must be in the range 0-7.
# queueSize  = size of output queue for EPICS
#pIp330PID = initIp330PID("Ip330PID_1", pIp330, 0, pDAC128V, 0, 20)

###############################################################################
# Initialize Greenspring IP-Unidig on second carrier board
# pIpUnidig = initIpUnidig(char *serverName,
#                          char *carrierName,
#                          char *siteName,
#                          int queueSize,
#                          int msecPoll,
#                          int intVec,
#                          int risingMask,
#                          int fallingMask,
#                          int biMask,
#                          int maxClients)
# iPiUnidig   = pointer to MPF server, used for quedEM interrupts
# serverName  = name to give this server
# carrierName = name of IPAC carrier from initIpacCarrier above
# siteName    = name of IP site, e.g. "IP_a"
# queueSize   = size of output queue for EPICS
# msecPoll    = polling time for input bits in msec.  Default=100.
# intVec      = interrupt vector
# risingMask  = mask of bits to generate interrupts on low to high (24 bits)
# fallingMask = mask of bits to generate interrupts on high to low (24 bits)
# biMask      = mask of bits to generate callbacks to bi record support
#               This can be a subset of (risingMask | fallingMask)
# maxClients  = Maximum number of callback tasks which will attach to this
#               IpUnidig server.  This does not refer to the number of EPICS clients.  
#               A value of 10 should certainly be safe.
#pIpUnidig = initIpUnidig("a-Unidig", carrier2, "IP_a", 20, 2000, 116, 1, 1, 0xffff, 10)

