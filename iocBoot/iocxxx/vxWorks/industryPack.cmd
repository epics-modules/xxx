
# BEGIN industryPack.cmd ------------------------------------------------------

# This configures the Industry Pack Support

# First carrier
# slot a: IP-Octal (serial RS-232)
# slot b: IpUnidig (digital I/O)
# slot c: Ip330 (A/D converter)
# slot c: IP-EP201 (FPGA)
# slot d: Dac128V (D/A converter)

###############################################################################
# Initialize IP carrier
# ipacAddCarrier(ipac_carrier_t *pcarrier, char *cardParams)
#   pcarrier   - pointer to carrier driver structure
#   cardParams - carrier-specific init parameters

# Select for MVME162 or MVME172 CPU board IP carrier.
#ipacAddMVME162("A:l=3,3 m=0xe0000000,64;B:l=3,3 m=0xe0010000,64;C:l=3,3 m=0xe0020000,64;D:l=3,3 m=0xe0030000,64")

# Select for SBS VIPC616-01 version IP carrier.
# ipacAddVIPC616_01("<a16 address>, <a32 address>")
# (fixed 8 MB of a32 memory per module)
#    OR
# ipacAddVIPC616_01("<a16 address>, <a24 address>, <size (kB) of a24 per module>")
#
#ipacAddVIPC616_01("0x3000,0xa0000000")
#ipacAddVIPC616_01("0x3400,0xa2000000")

# Select for Tews TVME-200 (also sold by SBS as VIPC626) version IP carrier.
# Config string is hex values of the six rotary switches on the board.
# In this example, the card is at a16 address 0x3000 ("30"), uses the interrupt
# assignment ("1"), uses the 32-bit address space for module memory
# ("f"), and maps that memory to A32 address 0xa000000 ("a0")
#
ipacAddTVME200("301fa0")
#ipacAddTVME200("341fa2")

# Select for Acromag AVME 9660 version IP Carrier.
# Config string starts with a hex number which sets the I/O base address
# of the card in the VME 16 addess space.(the factory default is 0x0000). J1's jumpers
# on the AVME 9660 must be set to match the selected A16 mem location.
# A mandatory comma is next followed by the VME interrupt level (0-7.)
# A 0 interrupt level means all interrupts are disabled.

# Next is slot = size, address. This determines if a slot is used and the IP module's A24 mem size
# and A24 mem location. Definition of entire config string below:
# ipacAddAvme96XX("A16 carrier mem location,int level,slot=IP A24 Memory Size,A24 IP Module Location")

# Configuration Example
# ipacAddAvme96XX("C000,3 A=2,800000 C=1,A00000")
# This carrier is at A16:C000 and generates level 3 interrupts. Slot A is configured for 2MB of mem space
# at A24:800000 and Slot C for 1MB of mem space at A24:A00000.
ipacAddAvme96XX("C000,3 A=2,800000 C=1,A00000")



# Print out report of IP modules
ipacReport(2)


# serial support
< $(PLATFORM)/serial.cmd

# user programmable glue electronics (requires Acromag IP-EP20x)
iocsh "common/softGlue.iocsh"

# Systran DAC128V
#< $(PLATFORM)/dac128V.cmd

# Analog I/O (Acromag IP330 ADC)
#< $(PLATFORM)/ip330.cmd

# SBS IpUnidig digital I/O
< $(PLATFORM)/ipUnidig.cmd

# END industryPack.cmd --------------------------------------------------------
