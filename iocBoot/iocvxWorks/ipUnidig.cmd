# Initialize Greenspring IP-Unidig
# initIpUnidig(char *portName,
#              int carrier,
#              int slot,
#              int msecPoll,
#              int intVec,
#              int risingMask,
#              int fallingMask,
#              int biMask,
#              int maxClients)
# portName  = name to give this asyn port
# carrier     = IPAC carrier number (0, 1, etc.)
# slot        = IPAC slot (0,1,2,3, etc.)
# msecPoll    = polling time for input bits in msec.  Default=100.
# intVec      = interrupt vector
# risingMask  = mask of bits to generate interrupts on low to high (24 bits)
# fallingMask = mask of bits to generate interrupts on high to low (24 bits)
initIpUnidig("Unidig1", 0, 1, 2000, 116, 0xfffffb, 0xfffffb)

# IP-Unidig binary I/O
dbLoadTemplate "IpUnidig.substitutions"

