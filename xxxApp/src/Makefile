TOP=../..

include $(TOP)/configure/CONFIG
#----------------------------------------
#  ADD MACRO DEFINITIONS AFTER THIS LINE
#=============================

# For Kate Feng's implementation of devScaler.c, which uses Till
# Straumann's basicIoOps.h to bridge any mismatch between endianness
# of Joerger scaler hardware and endianness of processor.
#USR_CFLAGS += -DHAS_IOOPS_H

#==================================================
# build a support library that some other application can use

#LIBRARY_IOC += xxxSupport

# xxxRecord.h will be created from xxxRecord.dbd
#DBDINC += xxxRecord
# install support-library .dbd into <top>/dbd
#DBD += xxxSupport.dbd

# The following are compiled and added to the Support library
#xxxSupport_SRCS += xxxRecord.c

#xxxSupport_LIBS += $(EPICS_BASE_IOC_LIBS)
#xxx_Common_LIBS += xxxSupport

#=============================
# build an ioc application

PROD_IOC = xxx

# Note that the order in which .dbd files are added to a list variable
# doesn't matter, but the order of libraries does.

##################################################################
# First, define xxx_Common_DBD and xxx_Common_LIBS from the modules
# defined in RELEASE
##################################################################
DBD += xxx_Common.dbd
xxx_Common_DBD += base.dbd

ifdef AREA_DETECTOR
        # areaDetector provides a Makefile for things it needs and supplies
        PROD_NAME = xxx_Common
        -include $(AREA_DETECTOR)/ADCore/ADApp/commonDriverMakefile
        # To add the simDetector uncomment the following lines
	#xxx_Common_DBD += simDetectorSupport.dbd
	#xxx_Common_LIBS += simDetector
endif
ifdef ASYN
	xxx_Common_DBD += asyn.dbd drvAsynSerialPort.dbd
	xxx_Common_DBD += drvAsynIPPort.dbd drvVxi11.dbd devGpib.dbd
	xxx_Common_LIBS += asyn
endif
ifdef STD
	xxx_Common_DBD += stdSupport.dbd
	xxx_Common_LIBS += std
endif
ifdef CALC
	xxx_Common_DBD += calcSupport.dbd
	xxx_Common_LIBS += calc
endif
ifdef BUSY
	xxx_Common_DBD += busySupport.dbd
	xxx_Common_LIBS += busy
endif
ifdef SSCAN
	xxx_Common_DBD += sscanSupport.dbd
	xxx_Common_LIBS += sscan
	ifdef SNCSEQ
		xxx_Common_DBD += sscanProgressSupport.dbd
		xxx_Common_LIBS += scanProgress
	endif
endif
ifdef AUTOSAVE
	xxx_Common_DBD += asSupport.dbd
	xxx_Common_LIBS += autosave
endif
ifdef OPTICS
	xxx_Common_DBD += opticsSupport.dbd
	xxx_Common_LIBS += optics
endif
ifdef MCA
	xxx_Common_DBD += mcaSupport.dbd
	xxx_Common_LIBS += mca
endif
ifdef IP
	xxx_Common_DBD += ipSupport.dbd
	xxx_Common_LIBS += ip
endif
ifdef QUADEM
	xxx_Common_DBD += drvAHxxx.dbd
	xxx_Common_LIBS += quadEM
endif
ifdef MOTOR
	xxx_Common_DBD += motorSupport.dbd devAcsMotor.dbd devAerotech.dbd
	xxx_Common_DBD += devAttocube.dbd devFaulhaberMotor.dbd devImsMotor.dbd
	xxx_Common_DBD += devKohzuMotor.dbd devMclennanMotor.dbd devMicos.dbd
	xxx_Common_DBD += devMicroMo.dbd devNewFocus.dbd devNewport.dbd
	xxx_Common_DBD += devOriel.dbd devPC6K.dbd devPIJena.dbd devPIMotor.dbd
	xxx_Common_DBD += devSPiiPlus.dbd devSmartMotorMotor.dbd devSoftMotor.dbd
	xxx_Common_DBD += devThorLabs.dbd motorRecord.dbd motorSimSupport.dbd

	xxx_Common_LIBS += Acs acsTech80 Aerotech Attocube Faulhaber Ims KohzuMotor
	xxx_Common_LIBS += Mclennan Micos MicroMo NewFocus Newport Oriel PI PIJena
	xxx_Common_LIBS += Parker SmartMotor ThorLabs softMotor motorSimSupport
	xxx_Common_LIBS += motor
endif
ifdef SNCSEQ
	xxx_Common_DBD += devSequencer.dbd
	xxx_Common_LIBS += seqDev seq pv
endif
ifdef STREAM
	xxx_Common_DBD += stream.dbd streamSynApps.dbd
	xxx_Common_LIBS += stream streamSynApps
endif
ifdef DEVIOCSTATS
  ifneq ($(OS_CLASS), WIN32)
	xxx_Common_DBD += devIocStats.dbd iocAdmin.dbd
	xxx_Common_LIBS += devIocStats
  endif
endif
xxx_Common_LIBS += $(EPICS_BASE_IOC_LIBS)

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
	ifdef QUADEM
		iocxxxVX_DBD += drvAPS_EM.dbd
	endif
	ifdef LOVE
		iocxxxVX_DBD += devLove.dbd
		xxx_LIBS_vxWorks += love
	endif
	ifdef IPAC
		iocxxxVX_DBD += tyGSOctal.dbd
		iocxxxVX_DBD += drvIpac.dbd
		xxx_LIBS_vxWorks += TyGSOctal Ipac
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

	ifdef DEVIOCSTATS
		iocxxxVX_DBD += devVxStats.dbd
	endif
endif

ifneq (,$(findstring linux, $(T_A)))
	DBD  += iocxxxLinux.dbd
	iocxxxLinux_DBD += xxx_Common.dbd

	ifdef MCA
		# If your host supports libpcap and libnet and you want to build Canberra network
		# support, set LINUX_NET_INSTALLED to YES in <synApps>/configure/CONFIG_SITE.
		ifeq ($(LINUX_NET_INSTALLED), YES)
			iocxxxLinux_DBD += mcaCanberraSupport.dbd
			xxx_LIBS_Linux += mcaCanberra
			xxx_SYS_LIBS_Linux += net pcap
		endif
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
