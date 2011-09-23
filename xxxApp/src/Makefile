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
ifeq (win32-x86,$(findstring win32-x86, $(T_A)))
	DBD  += iocxxxWin32.dbd
	iocxxxWin32_DBD += xxxCommonInclude.dbd

	# If your host supports libpcap and libnet and you want to build Canberra network
	# support uncomment the following line
	#iocxxxWin32_DBD += mcaCanberraSupport.dbd

	# If you want to build parallel port or USB interfaces to Saturn and/or xMAP DXP
	# then uncomment the following lines
	iocxxxWin32_DBD += dxpSupport.dbd
	iocxxxWin32_DBD += ADSupport.dbd  NDFileNetCDF.dbd
	xxx_LIBS_WIN32 += dxp handel
	xxx_LIBS_WIN32 += ADBase NDPlugin netCDF
	xxx_LIBS_WIN32 += DLPORTIO PlxApi
	xxx_SYS_LIBS_WIN32 += setupapi

	ifdef DEVIOCSTATS
		iocxxxWin32_DBD += devIocStats.dbd iocAdmin.dbd
	endif
endif

ifeq (windows-x64,$(findstring windows-x64, $(T_A)))
	DBD  += iocxxxWin64.dbd
	iocxxxWin64_DBD += xxxCommonInclude.dbd

	# If your host supports libpcap and libnet and you want to build Canberra network
	# support uncomment the following line
	iocxxxWin32_DBD += mcaCanberraSupport.dbd

	ifdef DEVIOCSTATS
		iocxxxWin32_DBD += devIocStats.dbd iocAdmin.dbd
	endif
endif

ifeq ($(EPICS_HOST_ARCH), cygwin-x86)
	DBD  += iocxxxCygwin.dbd
	iocxxxCygwin_DBD += xxxCommonInclude.dbd

	# If you want to build parallel port or USB interfaces to Saturn and/or xMAP DXP
	# then uncomment the following six lines
	#iocxxxCygwin_DBD += dxpSupport.dbd
	#iocxxxCygwin_DBD += ADSupport.dbd NDFileNetCDF.dbd
	#xxx_LIBS_cygwin32 += dxp handel
	#xxx_LIBS_cygwin32 += ADBase NDPlugin netCDF
	#xxx_SYS_LIBS_cygwin32 += DLPORTIO PlxApi
	#xxx_SYS_LIBS_cygwin32 += setupapi

	xxx_SYS_LIBS_cygwin32 += $(CYGWIN_RPC_LIB)

	ifdef DEVIOCSTATS
		iocxxxCygwin_DBD += devIocStats.dbd iocAdmin.dbd
	endif

endif

ifeq (vxWorks,$(findstring vxWorks, $(T_A)))
	DBD  += iocxxxVX.dbd
	#iocxxxVX_DBD += iocxxxVXInclude.dbd

	iocxxxVX_DBD += xxxCommonInclude.dbd

	iocxxxVX_DBD += vmeVXSupport.dbd
	iocxxxVX_DBD += stdVXSupport.dbd
	iocxxxVX_DBD += ipVXSupport.dbd
	iocxxxVX_DBD += SIS38XXSupport.dbd
	iocxxxVX_DBD += ipUnidigSupport.dbd
	iocxxxVX_DBD += dac128VSupport.dbd
	iocxxxVX_DBD += ip330Support.dbd

	iocxxxVX_DBD += camacSupport.dbd
	iocxxxVX_DBD += devCamacSupport.dbd
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
	ifndef DEVIOCSTATS
		iocxxxVX_DBD += vxStats.dbd
	endif
	iocxxxVX_DBD += softGlueSupport.dbd
	# from motor
	iocxxxVX_DBD += devDeltaTau.dbd
	iocxxxVX_DBD += devOms.dbd

	ifdef DEVIOCSTATS
		iocxxxVX_DBD += devIocStats.dbd iocAdmin.dbd
		iocxxxVX_DBD += devVxStats.dbd
	endif
endif

ifneq ("",$(findstring linux, $(T_A)))
	DBD  += iocxxxLinux.dbd
	iocxxxLinux_DBD += xxxCommonInclude.dbd
	iocxxxLinux_DBD += ADSupport.dbd  NDFileNetCDF.dbd
	xxx_LIBS_Linux += ADBase NDPlugin netCDF
	iocxxxLinux_DBD += simDetectorSupport.dbd commonDriverSupport.dbd
	xxx_LIBS_Linux += simDetector

	# If your host supports libpcap and libnet and you want to build Canberra network
	# support, set LINUX_NET_INSTALLED to YES in <synApps>/configure/CONFIG_SITE.
	ifeq ($(LINUX_NET_INSTALLED), YES)
		iocxxxLinux_DBD += mcaCanberraSupport.dbd
		xxx_LIBS_Linux += mcaCanberra
		xxx_SYS_LIBS_Linux += net pcap
	endif
	# If your host supports parallel port or USB interfaces to Saturn DXP, set
	# LINUX_USB_INSTALLED to YES in <synApps>/configure/CONFIG_SITE.
	ifeq ($(LINUX_USB_INSTALLED), YES)
		iocxxxLinux_DBD += dxpSupport.dbd
		xxx_LIBS_Linux  += dxp handel
		xxx_SYS_LIBS_Linux += usb
	endif

	ifdef DEVIOCSTATS
		iocxxxLinux_DBD += devIocStats.dbd iocAdmin.dbd
	endif
endif

ifeq ($(OS_CLASS), solaris)
	DBD  += iocxxx_solaris.dbd
	iocxxx_solaris_DBD += xxxCommonInclude.dbd
	ifdef DEVIOCSTATS
		iocxxx_solaris_DBD += devIocStats.dbd iocAdmin.dbd
		xxx_SYS_LIBS_solaris += kstat
	endif
endif

ifeq ($(OS_CLASS), Darwin)
	DBD  += iocxxxDarwin.dbd
	iocxxxDarwin_DBD += xxxCommonInclude.dbd
	ifdef DEVIOCSTATS
		iocxxxDarwin_DBD += devIocStats.dbd iocAdmin.dbd
	endif
endif



# <name>_registerRecordDeviceDriver.cpp will be created from <name>.dbd
xxx_SRCS_vxWorks  += iocxxxVX_registerRecordDeviceDriver.cpp
xxx_SRCS_Linux    += iocxxxLinux_registerRecordDeviceDriver.cpp     xxxMain.cpp
ifeq ($(T_A),win32-x86)
xxx_SRCS_WIN32    += iocxxxWin32_registerRecordDeviceDriver.cpp     xxxMain.cpp
endif
ifeq ($(T_A),windows-x64)
xxx_SRCS_WIN32    += iocxxxWin64_registerRecordDeviceDriver.cpp     xxxMain.cpp
endif
xxx_SRCS_cygwin32 += iocxxxCygwin_registerRecordDeviceDriver.cpp    xxxMain.cpp
xxx_SRCS_solaris  += iocxxx_solaris_registerRecordDeviceDriver.cpp  xxxMain.cpp
xxx_SRCS_Darwin   += iocxxxDarwin_registerRecordDeviceDriver.cpp    xxxMain.cpp

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
xxx_Common_LIBS += asyn
xxx_Common_LIBS += stream streamSynApps
xxx_Common_LIBS += seqDev seq pv
xxx_Common_LIBS += $(EPICS_BASE_IOC_LIBS)
ifdef DEVIOCSTATS
	xxx_Common_LIBS += devIocStats
endif

ifdef ALLEN_BRADLEY
xxx_LIBS_vxWorks += allenBradley
endif
xxx_LIBS_vxWorks += SIS38XX
xxx_LIBS_vxWorks += mcaCanberra
xxx_LIBS_vxWorks += ip330
xxx_LIBS_vxWorks += ipUnidig
xxx_LIBS_vxWorks += dac128V
xxx_LIBS_vxWorks += quadEM
xxx_LIBS_vxWorks += camac devCamac
xxx_LIBS_vxWorks += love
ifndef DEVIOCSTATS
	xxx_LIBS_vxWorks += vxStats
endif
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
xxx_LIBS_Darwin   += $(xxx_Common_LIBS)


# areaDetector provides a Makefile for things it needs and supplies
ifneq (solaris,$(findstring solaris, $(T_A)))
ifneq (vxWorks,$(findstring vxWorks, $(T_A)))
	-include $(AREA_DETECTOR)/ADApp/commonDriverMakefile
endif
endif
#===========================

include $(TOP)/configure/RULES
#----------------------------------------
#  ADD RULES AFTER THIS LINE
