
# BEGIN ipUnidig.cmd ----------------------------------------------------------

# Initialize Greenspring IP-Unidig
# initIpUnidig(char *portName,
#              int carrier,
#              int slot,
#              int msecPoll,
#              int intVec,
#              int risingMask,
#              int fallingMask)
# portName  = name to give this asyn port
# carrier     = IPAC carrier number (0, 1, etc.)
# slot        = IPAC slot (0,1,2,3, etc.)
# msecPoll    = polling time for input bits that don't use interrupts in msec.
# intVec      = interrupt vector
# risingMask  = mask of bits to generate interrupts on low to high (24 bits)
# fallingMask = mask of bits to generate interrupts on high to low (24 bits)

# Note: We have the quadEM connected to channel 3 (starting from 1).  Its driver will
# enable interrupts on one edge of the pulses, so we don't need to do it here.  All other
# inputs generate interrupts on both rising and falling edge
initIpUnidig("Unidig1", 0, 1, 2000, 116, 0xfffffb, 0xfffffb)

# IP-Unidig binary I/O
dbLoadTemplate "ipUnidig.substitutions"

# END ipUnidig.cmd ------------------------------------------------------------
