TOP=../..

include $(TOP)/configure/CONFIG
#----------------------------------------
#  ADD MACRO DEFINITIONS AFTER THIS LINE
#=============================

# For Kate Feng's implementation of devScaler.c, which uses Till
# Straumann's basicIoOps.h to bridge any mismatch between endianness
# of Joerger scaler hardware and endianness of processor.
#USR_CFLAGS += -DHAS_IOOPS_H

#=============================
# build an ioc application

PROD_IOC = xxx

# Note that the order in which .dbd files and libraries are added to a list
# variable is important.  For .dbd files, things must be defined before they
# are referenced by a later .dbd file.  For libraries, things must be referenced
# before they are searched for; otherwise they won't be included.

# Custom stuff in development

##################################################################
# First, define xxx_Common_DBD and xxx_Common_LIBS from the modules
# defined in RELEASE
##################################################################
DBD += xxx_Common.dbd
xxx_Common_DBD += base.dbd

#ifdef TDS3000
#	xxx_Common_DBD += devTDS3000.dbd
#	xxx_Common_LIBS := devTDS3000 $(xxx_Common_LIBS)
#endif

#ifdef CAPUTLOG
#	xxx_Common_DBD += caPutLog.dbd
#	xxx_Common_LIBS := caPutLog $(xxx_Common_LIBS)
#endif

ifdef CAPUTRECORDER
	xxx_Common_DBD += caputRecorder.dbd
	xxx_Common_LIBS := caputRecorder $(xxx_Common_LIBS)
endif

ifdef SNCSEQ
	ifeq (seq-2-1, $(findstring seq-2-1, $(SNCSEQ)))
		xxx_Common_DBD += devSequencer.dbd
		xxx_Common_LIBS := seqDev seq pv $(xxx_Common_LIBS)
	else ifeq (seq-2.1, $(findstring seq-2.1, $(SNCSEQ)))
		xxx_Common_DBD += devSequencer.dbd
		xxx_Common_LIBS := seqDev seq pv $(xxx_Common_LIBS)
	else
		# seq 2.2.
		xxx_Common_LIBS := seq pv $(xxx_Common_LIBS)
	endif
endif

ifdef ASYN
	xxx_Common_DBD += asyn.dbd drvAsynSerialPort.dbd
	xxx_Common_DBD += drvAsynIPPort.dbd drvVxi11.dbd devGpib.dbd
	xxx_Common_LIBS := asyn $(xxx_Common_LIBS)
endif

ifdef STD
	xxx_Common_DBD += stdSupport.dbd
	xxx_Common_LIBS := std $(xxx_Common_LIBS)
endif

ifdef CALC
	xxx_Common_DBD += calcSupport.dbd
	xxx_Common_LIBS := calc $(xxx_Common_LIBS)
endif

ifdef BUSY
	xxx_Common_DBD += busySupport.dbd
	xxx_Common_LIBS := busy $(xxx_Common_LIBS)
endif

ifdef SSCAN
	xxx_Common_DBD += sscanSupport.dbd
	xxx_Common_LIBS := sscan $(xxx_Common_LIBS)
	ifdef SNCSEQ
		xxx_Common_DBD += sscanProgressSupport.dbd
		xxx_Common_LIBS := scanProgress $(xxx_Common_LIBS)
	endif
endif

ifdef AUTOSAVE
	xxx_Common_DBD += asSupport.dbd
	xxx_Common_LIBS := autosave $(xxx_Common_LIBS)
endif

ifdef OPTICS
	xxx_Common_DBD += opticsSupport.dbd
	xxx_Common_LIBS := optics $(xxx_Common_LIBS)
endif

ifdef MCA
	xxx_Common_DBD += mcaSupport.dbd
	xxx_Common_LIBS := mca $(xxx_Common_LIBS)
endif

ifdef IP
	xxx_Common_DBD += ipSupport.dbd
	xxx_Common_LIBS := ip $(xxx_Common_LIBS)
endif

ifdef MODBUS
	xxx_Common_DBD += modbusSupport.dbd
	xxx_Common_LIBS := modbus $(xxx_Common_LIBS)
endif

ifdef MOTOR
	xxx_Common_DBD += motorSupport.dbd devAcsMotor.dbd devAerotech.dbd
	xxx_Common_DBD += devAttocube.dbd devFaulhaberMotor.dbd devImsMotor.dbd
	xxx_Common_DBD += devKohzuMotor.dbd devMclennanMotor.dbd devMicos.dbd
	xxx_Common_DBD += devMicroMo.dbd devNewFocus.dbd devNewport.dbd
  ifdef SNCSEQ
	xxx_Common_DBD += devAerotechSeq.dbd devNewportSeq.dbd
  endif
	xxx_Common_DBD += devOriel.dbd devPC6K.dbd devPIJena.dbd devPIMotor.dbd
	xxx_Common_DBD += devSPiiPlus.dbd devSmartMotorMotor.dbd devSoftMotor.dbd
	xxx_Common_DBD += devThorLabs.dbd motorSimSupport.dbd

	xxx_Common_LIBS := motor $(xxx_Common_LIBS)
	xxx_Common_LIBS := Acs acsTech80 Aerotech Attocube Faulhaber Ims KohzuMotor $(xxx_Common_LIBS)
	xxx_Common_LIBS := Mclennan Micos MicroMo NewFocus Newport Oriel PI PIJena $(xxx_Common_LIBS)
	xxx_Common_LIBS := Parker SmartMotor ThorLabs softMotor motorSimSupport $(xxx_Common_LIBS)
endif

ifdef STREAM
	xxx_Common_DBD += stream.dbd streamSynApps.dbd
	xxx_Common_LIBS := stream streamSynApps $(xxx_Common_LIBS)
endif

ifdef DEVIOCSTATS
	xxx_Common_DBD += devIocStats.dbd iocAdmin.dbd
	xxx_Common_LIBS := devIocStats $(xxx_Common_LIBS)
endif

ifdef ETHERIP
	xxx_Common_DBD += ether_ip.dbd
	xxx_Common_LIBS := ether_ip $(xxx_Common_LIBS)
endif

ifdef ALIVE
	xxx_Common_DBD += aliveSupport.dbd
	xxx_Common_LIBS := alive $(xxx_Common_LIBS)
endif

ifdef DELAYGEN
	xxx_Common_DBD += delaygenSupport.dbd
	xxx_Common_LIBS := delaygen $(xxx_Common_LIBS)
endif

ifdef VAC
	xxx_Common_DBD += vacSupport.dbd
	xxx_Common_LIBS := vac $(xxx_Common_LIBS)
endif

#ifdef FLY
#	xxx_Common_DBD += flySupport.dbd
#	xxx_Common_LIBS := fly $(xxx_Common_LIBS)
#endif

xxx_Common_LIBS := $(xxx_Common_LIBS) $(EPICS_BASE_IOC_LIBS)

##################################################################


ifeq (win32-x86,$(findstring win32-x86, $(T_A)))

	DBD  += iocxxxWin32.dbd
	iocxxxWin32_DBD += xxx_Common.dbd

	ifdef MCA
		# If your host supports libpcap and libnet and you want to build
		# Canberra network support uncomment the following lines
		#iocxxxWin32_DBD += mcaCanberraSupport.dbd
		#xxx_LIBS_WIN32 += mcaCanberra
		#xxx_LIBS_WIN32 += wpcap Packet
	endif

	ifdef DXP
		# If you want to build parallel port or USB interfaces to Saturn and/or
		# xMAP DXP, then uncomment the following lines
		iocxxxWin32_DBD += dxpSupport.dbd
		xxx_LIBS_WIN32 += dxp handel
		xxx_LIBS_WIN32 += DLPORTIO PlxApi
		xxx_SYS_LIBS_WIN32 += setupapi
	endif

	ifdef AREA_DETECTOR
		# areaDetector provides a Makefile for things it needs and supplies
		PROD_NAME = AD
		-include $(ADCORE)/ADApp/commonDriverMakefile
		iocxxxWin32_DBD += ADSupport.dbd NDPluginSupport.dbd
		xxx_LIBS_WIN32 += $(AD_LIBS)
		ifdef ADEXAMPLE
			# To add the simDetector uncomment the following lines
			iocxxxLinux_DBD += simDetectorSupport.dbd
			xxx_LIBS_WIN32 += simDetector
		endif
	endif
endif

ifeq (windows-x64,$(findstring windows-x64, $(T_A)))
	DBD  += iocxxxWin64.dbd
	iocxxxWin64_DBD += xxx_Common.dbd

	ifdef MCA
		# If your host supports libpcap and libnet and you want to build Canberra network
		# support uncomment the following line
		iocxxxWin64_DBD += mcaCanberraSupport.dbd
		xxx_LIBS_WIN32 += mcaCanberra
		xxx_LIBS_WIN32 += wpcap Packet
	endif

	ifdef AREA_DETECTOR
		# areaDetector provides a Makefile for things it needs and supplies
		PROD_NAME = AD
		-include $(ADCORE)/ADApp/commonDriverMakefile
		iocxxxWin64_DBD += ADSupport.dbd NDPluginSupport.dbd
		xxx_LIBS_WIN32 += $(AD_LIBS)
		# To add the simDetector uncomment the following lines
		iocxxxLinux_DBD += simDetectorSupport.dbd
		xxx_LIBS_WIN32 += simDetector
	endif
endif

ifeq ($(EPICS_HOST_ARCH), cygwin-x86)
	DBD  += iocxxxCygwin.dbd
	iocxxxCygwin_DBD += xxx_Common.dbd

	ifdef DXP
		# If you want to build parallel port or USB interfaces to Saturn and/or
		# xMAP DXP,then uncomment the following lines
		#iocxxxCygwin_DBD += dxpSupport.dbd
		#xxx_LIBS_cygwin32 += dxp handel
		#xxx_SYS_LIBS_cygwin32 += DLPORTIO PlxApi setupapi
	endif

	xxx_SYS_LIBS_cygwin32 += $(CYGWIN_RPC_LIB)

endif

ifeq (vxWorks,$(findstring vxWorks, $(T_A)))
	DBD  += iocxxxVX.dbd
	iocxxxVX_DBD += xxx_Common.dbd

	ifdef ALLEN_BRADLEY
		xxx_LIBS_vxWorks += allenBradley
	endif

	ifdef QUADEM
		iocxxxVX_DBD += drvAHxxx.dbd
		iocxxxVX_DBD += drvAPS_EM.dbd
		xxx_LIBS_vxWorks += quadEM
	endif

	ifdef AREA_DETECTOR
		# areaDetector provides a Makefile for things it needs and supplies
		PROD_NAME = AD
		-include $(ADCORE)/ADApp/commonDriverMakefile
		iocxxxVX_DBD += ADSupport.dbd NDPluginSupport.dbd
		xxx_LIBS_vxWorks += $(AD_LIBS)
		# To add the simDetector uncomment the following lines
		iocxxxVX_DBD += simDetectorSupport.dbd
		xxx_LIBS_vxWorks += simDetector
	endif

	ifdef VME
		iocxxxVX_DBD += vmeVXSupport.dbd
		xxx_LIBS_vxWorks += vme
	endif

	ifdef STD
		iocxxxVX_DBD += stdVXSupport.dbd
	endif

	ifdef IP
		iocxxxVX_DBD += ipVXSupport.dbd
	endif

	ifdef MCA
		iocxxxVX_DBD += SIS38XXSupport.dbd
		iocxxxVX_DBD += mcaCanberraSupport.dbd
		xxx_LIBS_vxWorks += SIS38XX
		xxx_LIBS_vxWorks += mcaCanberra
	endif

	ifdef IPUNIDIG
		iocxxxVX_DBD += ipUnidigSupport.dbd
		xxx_LIBS_vxWorks += ipUnidig
	endif

	ifdef DAC128V
		iocxxxVX_DBD += dac128VSupport.dbd
		xxx_LIBS_vxWorks += dac128V
	endif

	ifdef IP330
		iocxxxVX_DBD += ip330Support.dbd
		xxx_LIBS_vxWorks += ip330
	endif

	ifdef CAMAC
		iocxxxVX_DBD += camacSupport.dbd
		iocxxxVX_DBD += devCamacSupport.dbd
		xxx_LIBS_vxWorks += camac devCamac
	endif

	ifdef ALLEN_BRADLEY
		iocxxxVX_DBD += allenBradley.dbd
	endif

	ifdef LOVE
		iocxxxVX_DBD += devLove.dbd
		xxx_LIBS_vxWorks += love
	endif

	ifdef IPAC
		iocxxxVX_DBD += tyGSOctal.dbd
		iocxxxVX_DBD += drvIpac.dbd
		xxx_LIBS_vxWorks += TyGSOctal Ipac
		iocxxxVX_DBD += IP520.dbd
		xxx_LIBS_vxWorks += IP520
	endif

	ifdef ASYN
		iocxxxVX_DBD += drvGsIP488.dbd
	endif

	ifdef SOFTGLUE
		iocxxxVX_DBD += softGlueSupport.dbd
		xxx_LIBS_vxWorks += softGlue
	endif

	ifdef MOTOR
		iocxxxVX_DBD += devDeltaTau.dbd
		iocxxxVX_DBD += devOms.dbd
		xxx_LIBS_vxWorks += oms DeltaTau
	endif

#	ifdef FLY
#		iocxxxVX_DBD += flyVXSupport.dbd
#		xxx_LIBS_vxWorks += fly
#	endif

endif

ifneq (,$(findstring linux, $(T_A)))
	DBD  += iocxxxLinux.dbd
	iocxxxLinux_DBD += xxx_Common.dbd

ifeq ($(HAVE_HDF5), YES)
ifeq ($(HAVE_SZIP), YES)

	ifdef QUADEM
		iocxxxLinux_DBD += drvAHxxx.dbd
		xxx_LIBS_Linux += quadEM
	endif

	ifdef AREA_DETECTOR
		# areaDetector provides a Makefile for things it needs and supplies
		PROD_NAME = AD
		-include $(ADCORE)/ADApp/commonDriverMakefile
		iocxxxLinux_DBD += ADSupport.dbd NDPluginSupport.dbd
		xxx_LIBS_Linux += $(AD_LIBS)
		# To add the simDetector uncomment the following lines
		iocxxxLinux_DBD += simDetectorSupport.dbd
		xxx_LIBS_Linux += simDetector
	endif

	ifdef DXP
		# If your host supports parallel port or USB interfaces to Saturn DXP, set
		# LINUX_USB_INSTALLED to YES in <synApps>/configure/CONFIG_SITE.
		ifeq ($(LINUX_USB_INSTALLED), YES)
			iocxxxLinux_DBD += dxpSupport.dbd
			xxx_LIBS_Linux  += dxp handel
			xxx_SYS_LIBS_Linux += usb
		endif
	endif

endif
endif

	ifdef MCA
		# If your host supports libpcap and libnet and you want to build Canberra network
		# support, set LINUX_NET_INSTALLED to YES in <synApps>/configure/CONFIG_SITE.
		ifeq ($(LINUX_NET_INSTALLED), YES)
			iocxxxLinux_DBD += mcaCanberraSupport.dbd
			xxx_LIBS_Linux += mcaCanberra
			xxx_SYS_LIBS_Linux += net pcap
		endif
	endif

	ifdef IPAC
		iocxxxLinux_DBD += drvIpac.dbd
		xxx_LIBS_Linux += Ipac
	endif

	ifdef SOFTGLUE
		iocxxxLinux_DBD += softGlueSupport.dbd
		xxx_LIBS_Linux += softGlue
	endif
endif

ifeq ($(OS_CLASS), Darwin)
	DBD  += iocxxxDarwin.dbd
	iocxxxDarwin_DBD += xxx_Common.dbd
endif



# <name>_registerRecordDeviceDriver.cpp will be created from <name>.dbd
xxx_SRCS_vxWorks  += iocxxxVX_registerRecordDeviceDriver.cpp
xxx_SRCS_Linux    += iocxxxLinux_registerRecordDeviceDriver.cpp     xxxMain.cpp
ifeq (win32-x86,$(findstring win32-x86, $(T_A)))
	xxx_SRCS_WIN32    += iocxxxWin32_registerRecordDeviceDriver.cpp     xxxMain.cpp
endif
ifeq (windows-x64,$(findstring windows-x64, $(T_A)))
	xxx_SRCS_WIN32    += iocxxxWin64_registerRecordDeviceDriver.cpp     xxxMain.cpp
endif
xxx_SRCS_cygwin32 += iocxxxCygwin_registerRecordDeviceDriver.cpp    xxxMain.cpp
xxx_SRCS_solaris  += iocxxx_solaris_registerRecordDeviceDriver.cpp  xxxMain.cpp
xxx_SRCS_Darwin   += iocxxxDarwin_registerRecordDeviceDriver.cpp    xxxMain.cpp



#The following adds support from base/src/vxWorks
xxx_OBJS_vxWorks += $(EPICS_BASE_BIN)/vxComLibrary

xxx_LIBS_vxWorks  += $(xxx_Common_LIBS)
xxx_LIBS_Linux    += $(xxx_Common_LIBS)
xxx_LIBS_solaris  += $(xxx_Common_LIBS)
xxx_LIBS_cygwin32 += $(xxx_Common_LIBS)
xxx_LIBS_WIN32    += $(xxx_Common_LIBS)
xxx_LIBS_Darwin   += $(xxx_Common_LIBS)

# Here's how to print out all gnumake variables
#$(foreach v, $(.VARIABLES), $(info $(v) = $($(v))))
# print out just one variable
#$(info SUPPORT = $(SUPPORT))

#===========================

include $(TOP)/configure/RULES
#----------------------------------------
#  ADD RULES AFTER THIS LINE

$(COMMON_DIR)/iocxxxWin32Include.dbd: $(COMMON_DIR)/xxx_Common.dbd
$(COMMON_DIR)/iocxxxWin64Include.dbd: $(COMMON_DIR)/xxx_Common.dbd
$(COMMON_DIR)/iocxxxCygwinInclude.dbd: $(COMMON_DIR)/xxx_Common.dbd
$(COMMON_DIR)/iocxxxVXInclude.dbd: $(COMMON_DIR)/xxx_Common.dbd
$(COMMON_DIR)/iocxxxLinuxInclude.dbd: $(COMMON_DIR)/xxx_Common.dbd
$(COMMON_DIR)/iocxxxDarwinInclude.dbd: $(COMMON_DIR)/xxx_Common.dbd

$(COMMON_DIR)/iocxxxWin32.dbd: $(COMMON_DIR)/xxx_Common.dbd
$(COMMON_DIR)/iocxxxWin64.dbd: $(COMMON_DIR)/xxx_Common.dbd
$(COMMON_DIR)/iocxxxCygwin.dbd: $(COMMON_DIR)/xxx_Common.dbd
$(COMMON_DIR)/iocxxxVX.dbd: $(COMMON_DIR)/xxx_Common.dbd
$(COMMON_DIR)/iocxxxLinux.dbd: $(COMMON_DIR)/xxx_Common.dbd
$(COMMON_DIR)/iocxxxDarwin.dbd: $(COMMON_DIR)/xxx_Common.dbd

iocxxxWin32.dbd$(DEP): $(COMMON_DIR)/xxx_Common.dbd
iocxxxWin64.dbd$(DEP): $(COMMON_DIR)/xxx_Common.dbd
iocxxxCygwin.dbd$(DEP): $(COMMON_DIR)/xxx_Common.dbd
iocxxxVX.dbd$(DEP): $(COMMON_DIR)/xxx_Common.dbd
iocxxxLinux.dbd$(DEP): $(COMMON_DIR)/xxx_Common.dbd
iocxxxDarwin.dbd$(DEP): $(COMMON_DIR)/xxx_Common.dbd
