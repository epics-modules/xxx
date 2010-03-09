
# BEGIN industryPack.cmd ------------------------------------------------------

# This configures the Industry Pack Support

# First carrier
# slot a: IP-Octal (serial RS-232)
# slot b: IpUnidig (digital I/O)
# slot c: Ip330 (A/D converter)
# slot d: Dac128V (D/A converter)

# Second carrier
# slot a: Empty
# slob b: IP-488 (GPIB)
# slot c: IP-Octal (serial RS-232)
# slot d: Empty

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
ipacAddVIPC616_01("0x3000,0xa0000000")
ipacAddVIPC616_01("0x3400,0xa2000000")

# Select for Tews TVME-200 (also sold by SBS as VIPC626) version IP carrier.
# Config string is hex values of the six rotary switches on the board.
# In this example, the card is at a16 address 0x3000 ("30"), uses the interrupt
# assignment ("2"), uses the 32-bit address space for module memory
# ("f"), and maps that memory to A32 address 0xa000000 ("a0")
#ipacAddTVME200("302fa0")
#ipacAddTVME200("342fa2")

# Print out report of IP modules
ipacReport(2)

# Note: the SBS Octal-232 modules are configured in serial.cmd
# and the SBS IP-488 modules are configured in gpib.cmd

# Systran DAC128V
< dac128V.cmd

# Analog I/O (Acromag IP330 ADC)
< ip330.cmd

# SBS IpUnidig digital I/O
< ipUnidig.cmd

# user programmable glue electronics (Requires Acromag IP-EP201 with custom
# firmware, and the softGlue module)
#< softGlue.cmd

# END industryPack.cmd --------------------------------------------------------
