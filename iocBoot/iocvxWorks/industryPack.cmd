# This configures the Industry Pack Support

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
#ipacAddMVME162("A:l=3,3 m=0xe0000000,64;B:l=3,3 m=0xe0010000,64;C:l=3,3 m=0xe0020000,64;D:l=3,3 m=0xe0030000,64")

# Select for SBS VIPC616-01 version IP carrier.
#ipacAddVIPC616_01("0x3000,0xa0000000")
#ipacAddVIPC616_01("0x3400,0xa2000000")

# Print out report of IP modules
ipacReport(2)

# Note: the SBS Octal-232 modules are configured in serial.cmd

# Systran DAC128V
< dac128V.cmd

# Analog I/O (Acromag IP330 ADC)
< ip330.cmd

# SBS IpUnidig digital I/O
< ipUnidig.cmd

