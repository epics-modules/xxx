# Setup the DXP CAMAC MCA.
# Change the following environment variable to point to the desired
# system configuration file
putenv("XIA_CONFIG=xiasystem.cfg")
# Set environment variables for the FiPPI files. 
# FIPPI0,FIPPI1,FIPPI2,FIPPI3 should point to the files for 
# decimation=0,2,4,6 respectively. FIPPI_DEFAULT should point to the
# file that will be loaded initially at boot time.
putenv("FIPPI0=f01x2p0g.fip")
putenv("FIPPI1=f01x2p2g.fip")
putenv("FIPPI2=f01x2p4g.fip")
putenv("FIPPI3=f01x2p6g.fip")
putenv("FIPPI_DEFAULT=f01x2p4g.fip")
# Set logging level (1=ERROR, 2=WARNING, 3=XXX, 4=DEBUG)
dxp_md_set_log_level(2)
dxp_initialize

# DXPConfig(serverName, detChan1, detChan2, detChan3, detChan4, queueSize)
DXPConfig("DXP1",  0,  1,  2,  3, 300)
DXPConfig("DXP2",  4,  5,  6,  7, 300)
DXPConfig("DXP3",  8,  9, 10, 11, 300)
DXPConfig("DXP4", 12, 13, 14, 15, 300)

dbLoadRecords("camacApp/Db/16element_dxp.db","P=xxx:med:", camac)

# Load all of the MCA and DXP records
dbLoadTemplate("16element_dxp.substitutions")
