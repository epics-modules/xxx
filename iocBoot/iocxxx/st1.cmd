< ../nfsCommands

cd "/home/beams/BCDA/epics/synApps_4_3/2id/iocBoot/iocxxx"

shellPromptSet "iocxxx1> "

< cdCommands
 
cd appbin
ld < mpfLib
ld < mpfServLib

cd startup

# For mv162
ipacAddCarrier(&ipmv162, "A:m=0xe0000000,64 l=3,3;D:m=0xe0010000,64 l=3,3")

carrier = "ipac"
initIpacCarrier(carrier, 0)

#start message router
routerInit
tcpMessageRouterServerStart(1,9900,"164.54.113.yyy",1500,40)

# slot a: IP-Octal (serial RS-232)
# slot b: 
# slot c: 
# slot d: 


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
# Port 0 is Generic Serial Record

initOctalUARTPort("UART[0]","octalUart0",0, 9600,"N",1,8,"N") /* Keithley 2000 */
initOctalUARTPort("UART[1]","octalUart0",1, 9600,"N",2,8,"N") /* SRS570 */
initOctalUARTPort("UART[2]","octalUart0",2, 19200,"N",1,8,"N") /* Love Ctrl */
initOctalUARTPort("UART[3]","octalUart0",3,19200,"N",1,8,"N") /* MM4000 */
initOctalUARTPort("UART[4]","octalUart0",4, 9600,"N",2,8,"N") /* SRS570 */
initOctalUARTPort("UART[5]","octalUart0",5, 9600,"N",1,8,"N") /* Keithley 2000 */
initOctalUARTPort("UART[6]","octalUart0",6, 9600,"N",1,8,"N") /* SMART PC */
initOctalUARTPort("UART[7]","octalUart0",7, 9600,"N",1,8,"N")

initSerialServer("a-Serial[0]","UART[0]",1000,20,"\r",1)
initSerialServer("a-Serial[1]","UART[1]",1000,20,"\r",1)
initSerialServer("a-Serial[2]","UART[2]",1000,20,"\r",1)
initSerialServer("a-Serial[3]","UART[3]",1000,20,"\r",1)
initSerialServer("a-Serial[4]","UART[4]",1000,20,"\r",1)
initSerialServer("a-Serial[5]","UART[5]",1000,20,"\r",1)
initSerialServer("a-Serial[6]","UART[6]",1000,20,"\r",1)

# Love controllers
#initOctalUARTPort("UART[7]","octalUart0",7,19200,"N",1,8,"N")
#initLoveServer("PORT7","UART[7]",112)

###############################################################################
# Initialize GPIB stuff

# Mark's version
#initGpibGsTi9914("GS-IP488-0",carrier,"IP_b",104)
#initGpibServer("GPIB0","GS-IP488-0",1024,1000)
# Ron's version
#initGpibGsTi9914("motorMod", carrier, "IP_b", 123)
#initGpibServer("gpib-server", "motorMod", 100, 30)

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
