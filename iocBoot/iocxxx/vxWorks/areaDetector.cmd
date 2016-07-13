# Create a simDetector driver
simDetectorConfig("SIM1", 640, 480, 1, 50, 50000000)
dbLoadRecords("$(AREA_DETECTOR)/ADApp/Db/ADBase.template",     "P=xxx:,R=cam1:,PORT=SIM1,ADDR=0,TIMEOUT=1")
dbLoadRecords("$(AREA_DETECTOR)/ADApp/Db/simDetector.template","P=xxx:,R=cam1:,PORT=SIM1,ADDR=0,TIMEOUT=1")

# Create a second simDetector driver
simDetectorConfig("SIM2", 300, 200, 1, 50, 50000000)
dbLoadRecords("$(AREA_DETECTOR)/ADApp/Db/ADBase.template",     "P=xxx:,R=cam2:,PORT=SIM2,ADDR=0,TIMEOUT=1")
dbLoadRecords("$(AREA_DETECTOR)/ADApp/Db/simDetector.template","P=xxx:,R=cam2:,PORT=SIM2,ADDR=0,TIMEOUT=1")

# Create a standard arrays plugin, set it to get data from first simDetector driver.
NDStdArraysConfigure("SIM1Image", 3, 0, "SIM1", 0, 2000000)
cmd = "P=xxx:,R=image1:,PORT=SIM1Image,ADDR=0,TIMEOUT=1,NDARRAY_PORT=SIM1,NDARRAY_ADDR=0"
dbLoadRecords("$(AREA_DETECTOR)/ADApp/Db/NDPluginBase.template",cmd)
cmd = "P=xxx:,R=image1:,PORT=SIM1Image,ADDR=0,TIMEOUT=1,TYPE=Int8,FTVL=UCHAR,NELEMENTS=1392640"
dbLoadRecords("$(AREA_DETECTOR)/ADApp/Db/NDStdArrays.template", cmd)

# Create a standard arrays plugin, set it to get data from second simDetector driver.
NDStdArraysConfigure("SIM2Image", 1, 0, "SIM2", 0, 2000000)
cmd ="P=xxx:,R=image2:,PORT=SIM2Image,ADDR=0,TIMEOUT=1,NDARRAY_PORT=SIM1,NDARRAY_ADDR=0"
dbLoadRecords("$(AREA_DETECTOR)/ADApp/Db/NDPluginBase.template", cmd)
cmd = "P=xxx:,R=image2:,PORT=SIM2Image,ADDR=0,TIMEOUT=1,TYPE=Int8,FTVL=UCHAR,NELEMENTS=1392640"
dbLoadRecords("$(AREA_DETECTOR)/ADApp/Db/NDStdArrays.template", cmd)
# Load the database to use with Stephen Mudie's IDL code
#dbLoadRecords("$(AREA_DETECTOR)/ADApp/Db/EPICS_AD_Viewer.template", "P=xxx:, R=image1:")

# Create a file saving plugin
NDFileNetCDFConfigure("SIM1File", 20, 0, "SIM1", 0)
cmd = "P=xxx:,R=netCDF1:,PORT=SIM1File,ADDR=0,TIMEOUT=1,NDARRAY_PORT=SIM1,NDARRAY_ADDR=0"
dbLoadRecords("$(AREA_DETECTOR)/ADApp/Db/NDPluginBase.template",cmd)
dbLoadRecords("$(AREA_DETECTOR)/ADApp/Db/NDFile.template",      "P=xxx:,R=netCDF1:,PORT=SIM1File,ADDR=0,TIMEOUT=1")

# Create an ROI plugin
NDROIConfigure("SIM1ROI", 20, 0, "SIM1", 0, 8, 20, 20000000)
cmd = "P=xxx:,R=ROI1:,  PORT=SIM1ROI,ADDR=0,TIMEOUT=1,NDARRAY_PORT=SIM1,NDARRAY_ADDR=0"
dbLoadRecords("$(AREA_DETECTOR)/ADApp/Db/NDPluginBase.template", cmd)
dbLoadRecords("$(AREA_DETECTOR)/ADApp/Db/NDROI.template",  "P=xxx:,R=ROI1:,  PORT=SIM1ROI,ADDR=0,TIMEOUT=1")
dbLoadRecords("$(AREA_DETECTOR)/ADApp/Db/NDROIN.template", "P=xxx:,R=ROI1:0:,PORT=SIM1ROI,ADDR=0,TIMEOUT=1,HIST_SIZE=256")
dbLoadRecords("$(AREA_DETECTOR)/ADApp/Db/NDROIN.template", "P=xxx:,R=ROI1:1:,PORT=SIM1ROI,ADDR=1,TIMEOUT=1,HIST_SIZE=256")
dbLoadRecords("$(AREA_DETECTOR)/ADApp/Db/NDROIN.template", "P=xxx:,R=ROI1:2:,PORT=SIM1ROI,ADDR=2,TIMEOUT=1,HIST_SIZE=256")
dbLoadRecords("$(AREA_DETECTOR)/ADApp/Db/NDROIN.template", "P=xxx:,R=ROI1:3:,PORT=SIM1ROI,ADDR=3,TIMEOUT=1,HIST_SIZE=256")
