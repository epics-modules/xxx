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

# <name>.dbd will be created from <name>Include.dbd
ifeq ($(OS_CLASS), WIN32)
	DBD  += iocxxxWin32.dbd
	iocxxxWin32_DBD += xxxCommonInclude.dbd

	# If your host supports libpcap and libnet and you want to build Canberra network
	# support uncomment the following line
	#iocxxxWin32_DBD += mcaCanberraSupport.dbd

	# If you want to build parallel port or USB interfaces to Saturn and/or xMAP DXP
	# then uncomment the following two lines
	iocxxxWin32_DBD += dxpSupport.dbd
	xxx_LIBS_WIN32 += dxp handel
endif

ifeq ($(EPICS_HOST_ARCH), cygwin-x86)
	DBD  += iocxxxCygwin.dbd
	iocxxxCygwin_DBD += xxxCommonInclude.dbd

	# If you want to build parallel port or USB interfaces to Saturn and/or xMAP DXP
	# then uncomment the following two lines
	iocxxxCygwin_DBD += dxpSupport.dbd
	xxx_LIBS_cygwin32 += dxp handel
endif

ifeq (vxWorks,$(findstring vxWorks, $(T_A)))
	DBD  += iocxxxVX.dbd
	#iocxxxVX_DBD += iocxxxVXInclude.dbd

	iocxxxVX_DBD += xxxCommonInclude.dbd

	iocxxxVX_DBD += vmeVXSupport.dbd
	iocxxxVX_DBD += stdVXSupport.dbd
	iocxxxVX_DBD += ipVXSupport.dbd
	iocxxxVX_DBD += mcaSISSupport.dbd
	iocxxxVX_DBD += ipUnidigSupport.dbd
	iocxxxVX_DBD += dac128VSupport.dbd
	iocxxxVX_DBD += ip330Support.dbd

	iocxxxVX_DBD += camacSupport.dbd
	iocxxxVX_DBD += devCamacSupport.dbd
	iocxxxVX_DBD += dxpSupport.dbd
ifdef ALLEN_BRADLEY
	iocxxxVX_DBD += allenBradley.dbd
endif
	iocxxxVX_DBD += quadEMSupport.dbd
	iocxxxVX_DBD += mcaCanberraSupport.dbd
	iocxxxVX_DBD += devLove.dbd
	# from ipac
	iocxxxVX_DBD += tyGSOctal.dbd
	iocxxxVX_DBD += drvIpac.dbd
	# from asyn
	iocxxxVX_DBD += drvGsIP488.dbd
	iocxxxVX_DBD += vxStats.dbd
	iocxxxVX_DBD += softGlueSupport.dbd
	# from motor
	iocxxxVX_DBD += devDeltaTau.dbd
	iocxxxVX_DBD += devOms.dbd
endif

ifeq ($(OS_CLASS), Linux)
	DBD  += iocxxxLinux.dbd
	iocxxxLinux_DBD += xxxCommonInclude.dbd

	# If your host supports libpcap and libnet and you want to build Canberra network
	# support, set LINUX_NET_INSTALLED to YES in <synApps>/configure/CONFIG_SITE.
	ifeq ($(LINUX_NET_INSTALLED), YES)
		iocxxxLinux_DBD += mcaCanberraSupport.dbd
		xxx_LIBS_Linux += mcaCanberra
	endif
	# If your host supports parallel port or USB interfaces to Saturn DXP, set
	# LINUX_USB_INSTALLED to YES in <synApps>/configure/CONFIG_SITE.
	ifeq ($(LINUX_USB_INSTALLED), YES)
		iocxxxLinux_DBD += dxpSupport.dbd
		xxx_LIBS_Linux  += dxp handel
	endif
endif

ifeq ($(OS_CLASS), solaris)
	DBD  += iocxxx_solaris.dbd
	iocxxx_solaris_DBD += xxxCommonInclude.dbd
endif




# <name>_registerRecordDeviceDriver.cpp will be created from <name>.dbd
xxx_SRCS_vxWorks  += iocxxxVX_registerRecordDeviceDriver.cpp
xxx_SRCS_Linux    += iocxxxLinux_registerRecordDeviceDriver.cpp     xxxMain.cpp
xxx_SRCS_WIN32    += iocxxxWin32_registerRecordDeviceDriver.cpp     xxxMain.cpp
xxx_SRCS_cygwin32 += iocxxxCygwin_registerRecordDeviceDriver.cpp    xxxMain.cpp
xxx_SRCS_solaris  += iocxxx_solaris_registerRecordDeviceDriver.cppa xxxMain.cpp

xxx_Common_LIBS += mca
xxx_Common_LIBS += calc
xxx_Common_LIBS += busy
xxx_Common_LIBS += sscan
xxx_Common_LIBS += autosave
xxx_Common_LIBS += optics
xxx_Common_LIBS += std
xxx_Common_LIBS += ip
xxx_Common_LIBS += Acs acsTech80 Aerotech Attocube Faulhaber Ims KohzuMotor Mclennan
xxx_Common_LIBS += Micos MicroMo NewFocus Newport Oriel PI PIJena Parker SmartMotor
xxx_Common_LIBS += ThorLabs softMotor motorSimSupport motor
#xxx_Common_LIBS += ADBase NDPlugin netCDF
xxx_Common_LIBS += simDetector NDPlugin netCDF ADBase
xxx_Common_LIBS += asyn
xxx_Common_LIBS += stream streamSynApps
xxx_Common_LIBS += seqDev seq pv
xxx_Common_LIBS += $(EPICS_BASE_IOC_LIBS)

ifdef ALLEN_BRADLEY
xxx_LIBS_vxWorks += allenBradley
endif
xxx_LIBS_vxWorks += mcaSIS
xxx_LIBS_vxWorks += mcaCanberra
xxx_LIBS_vxWorks += ip330
xxx_LIBS_vxWorks += ipUnidig
xxx_LIBS_vxWorks += dac128V
xxx_LIBS_vxWorks += quadEM
xxx_LIBS_vxWorks += camac devCamac
xxx_LIBS_vxWorks += dxp handel
xxx_LIBS_vxWorks += love
xxx_LIBS_vxWorks += vxStats
xxx_LIBS_vxWorks += vme
xxx_LIBS_vxWorks += TyGSOctal Ipac
xxx_LIBS_vxWorks += oms DeltaTau
xxx_LIBS_vxWorks += softGlue

#The following adds support from base/src/vxWorks
xxx_OBJS_vxWorks += $(EPICS_BASE_BIN)/vxComLibrary

xxx_LIBS_vxWorks  += $(xxx_Common_LIBS)
xxx_LIBS_Linux    += $(xxx_Common_LIBS)
xxx_LIBS_solaris  += $(xxx_Common_LIBS)
xxx_LIBS_cygwin32 += $(xxx_Common_LIBS)
xxx_LIBS_WIN32    += $(xxx_Common_LIBS)

# If the host has libnet and libpcap for mca/Canberra support
# uncomment the following line.
#xxx_SYS_LIBS_Linux += net pcap

# For USB support on Saturn uncomment the following line
xxx_SYS_LIBS_Linux += usb

# This is needed (and provided) by areaDetector on Linux and WIN32
xxx_LIBS_WIN32        += PvAPI ImageLib
xxx_LIBS_Linux        += PvAPI ImageLib

# This is needed by dxp on cygwin and WIN32
xxx_SYS_LIBS_cygwin32 += DLPORTIO PlxApi setupapi
xxx_LIBS_WIN32        += DLPORTIO PlxApi
xxx_SYS_LIBS_WIN32    += setupapi

# This is needed by saveData and asyn VXI-11 on cygwin
xxx_SYS_LIBS_cygwin32 += rpc

# areaDetector needs these
xxx_SYS_LIBS_solaris   += tiff
xxx_LIBS_solaris   += jpeg sz z
xxx_LIBS_solaris += NeXus hdf5_cpp hdf5

# areaDetector needs (and provides) these
xxx_LIBS_WIN32    += libtiff jpeg libNeXus.dll
xxx_LIBS_cygwin32 += libtiff jpeg libNeXus.dll


# To use versions of these libraries supplied with areaDetector use this line
xxx_LIBS_Linux        += NeXus mfhdf df hdf5 mxml
# To use system versions of these libraries use this line
#xxx_SYS_LIBS_Linux    += NeXus mfhdf df hdf5 mxml

# To use versions of these libraries supplied with areaDetector use this line
xxx_LIBS_Linux        += tiff jpeg z
# To use system versions of these libraries use this line
#xxx_SYS_LIBS_Linux    += tiff jpeg z

#===========================

include $(TOP)/configure/RULES
#----------------------------------------
#  ADD RULES AFTER THIS LINE
