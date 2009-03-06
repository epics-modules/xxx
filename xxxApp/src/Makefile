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

#=============================
# build an ioc application

PROD_IOC_DEFAULT = xxx
PROD_IOC_solaris = xxx

# <name>.dbd will be created from <name>Include.dbd
ifeq ($(OS_CLASS), WIN32)
DBD  += iocxxxWin32.dbd
else
ifeq ($(EPICS_HOST_ARCH), cygwin-x86)
DBD  += iocxxxCygwin.dbd
else
ifeq ($(OS_CLASS), vxWorks)
DBD  += iocxxxVX.dbd
else
ifeq ($(OS_CLASS), Linux)
DBD  += iocxxxLinux.dbd
else
ifeq ($(OS_CLASS), solaris)
DBD  += iocxxx_solaris.dbd
else
DBD  += iocxxx.dbd
endif
endif
endif
endif
endif

# If your host supports libpcap and libnet and you want to build Canberra network
# support, set LINUX_NET_INSTALLED to YES in <synApps>/configure/CONFIG_SITE.
iocxxxLinux_DBD += xxxCommonInclude.dbd
ifneq ($(OS_CLASS), Linux)
iocxxxLinux_DBD += mcaCanberraSupport.dbd
else
ifeq ($(LINUX_NET_INSTALLED), YES)
iocxxxLinux_DBD += mcaCanberraSupport.dbd
endif
endif
# If your host supports parallel port or USB interfaces to Saturn DXP, set
# LINUX_USB_INSTALLED to YES in <synApps>/configure/CONFIG_SITE.
ifneq ($(OS_CLASS), Linux)
iocxxxLinux_DBD += dxpSupport.dbd
else
ifeq ($(OS_CLASS), Linux)
ifeq ($(LINUX_USB_INSTALLED), YES)
iocxxxLinux_DBD += dxpSupport.dbd
endif
endif
endif


# <name>_registerRecordDeviceDriver.cpp will be created from <name>.dbd
xxx_SRCS_DEFAULT  += iocxxx_registerRecordDeviceDriver.cpp          xxxMain.cpp
xxx_SRCS_vxWorks  += iocxxxVX_registerRecordDeviceDriver.cpp
xxx_SRCS_Linux    += iocxxxLinux_registerRecordDeviceDriver.cpp     xxxMain.cpp
xxx_SRCS_WIN32    += iocxxxWin32_registerRecordDeviceDriver.cpp     xxxMain.cpp
xxx_SRCS_cygwin32 += iocxxxCygwin_registerRecordDeviceDriver.cpp    xxxMain.cpp
xxx_SRCS_solaris  += iocxxx_solaris_registerRecordDeviceDriver.cppa xxxMain.cpp
xxx_SRCS_vxWorks  += -nil-

#xxx_Common_LIBS += xxxSupport
xxx_Common_LIBS += mca
xxx_Common_LIBS += calc
xxx_Common_LIBS += busy
xxx_Common_LIBS += sscan
xxx_Common_LIBS += autosave
xxx_Common_LIBS += optics
xxx_Common_LIBS += vme
xxx_Common_LIBS += std
xxx_Common_LIBS += ip
xxx_Common_LIBS += brukerCCD
xxx_Common_LIBS += marCCD
xxx_Common_LIBS += roperCCD

xxx_Common_LIBS += Acs Faulhaber Ims Mclennan Micos MicroMo NewFocus
xxx_Common_LIBS += Newport PI Parker
xxx_Common_LIBS += softMotor motorSimSupport motor

xxx_Common_LIBS += asyn
#xxx_Common_LIBS += stream streamSynApps
xxx_Common_LIBS += seqDev seq pv
xxx_Common_LIBS += $(EPICS_BASE_IOC_LIBS)

xxx_vxWorks_LIBS += allenBradley
xxx_vxWorks_LIBS += mcaSIS
xxx_vxWorks_LIBS += mcaCanberra
xxx_vxWorks_LIBS += ip330
xxx_vxWorks_LIBS += ipUnidig
xxx_vxWorks_LIBS += dac128V
xxx_vxWorks_LIBS += quadEM
xxx_vxWorks_LIBS += camac devCamac
xxx_vxWorks_LIBS += dxp handel
#xxx_vxWorks_LIBS += love
xxx_vxWorks_LIBS += vxStats
xxx_vxWorks_LIBS += TyGSOctal Ipac
xxx_vxWorks_LIBS += oms DeltaTau

#The following adds support from base/src/vxWorks
xxx_OBJS_vxWorks += $(EPICS_BASE_BIN)/vxComLibrary

ifeq ($(LINUX_USB_INSTALLED), YES)
xxx_Linux_LIBS  += dxp handel
endif
ifeq ($(LINUX_NET_INSTALLED), YES)
xxxLinux_LIBS += mcaCanberra
endif

xxx_cygwin_LIBS += dxp handel

xxx_WIN32_LIBS += dxp handel

#xxx_solaris_LIBS += genSub
#xxx_solaris_LIBS += mca
xxx_solaris_LIBS += calc
xxx_solaris_LIBS += busy
xxx_solaris_LIBS += sscan
xxx_solaris_LIBS += autosave
xxx_solaris_LIBS += optics
#xxx_solaris_LIBS += vme
xxx_solaris_LIBS += std
#xxx_solaris_LIBS += ip
#xxx_solaris_LIBS += brukerCCD
#xxx_solaris_LIBS += marCCD
#xxx_solaris_LIBS += roperCCD
xxx_solaris_LIBS += motor softMotor motorSimSupport
xxx_solaris_LIBS += asyn
xxx_solaris_LIBS += seqDev seq pv
xxx_solaris_LIBS += $(EPICS_BASE_IOC_LIBS)


xxx_LIBS_DEFAULT = $(xxx_Common_LIBS)
xxx_LIBS_vxWorks = $(xxx_vxWorks_LIBS) $(xxx_Common_LIBS)
xxx_LIBS_Linux   = $(xxx_Linux_LIBS)   $(xxx_Common_LIBS)
xxx_LIBS_solaris = $(xxx_solaris_LIBS)
xxx_LIBS_cygwin32 = $(xxx_cygwin_LIBS) $(xxx_Common_LIBS)
xxx_LIBS_WIN32    = $(xxx_WIN32_LIBS)  $(xxx_Common_LIBS)

# If the host has libnet and libpcap for mca/Canberra support
# uncomment the following line.
#xxx_SYS_LIBS_Linux += net pcap
# For USB support on Saturn
#xxx_SYS_LIBS_Linux += usb
xxx_SYS_LIBS_vxWorks += -nil-

# This is needed by areaDetector on Linux and WIN32
xxx_LIBS_WIN32        += PvAPI
ifeq ($(LINUX_TIFF_INSTALLED), YES)
xxx_LIBS_Linux        += PvAPI
endif

# This is needed by dxp on cygwin and WIN32
xxx_SYS_LIBS_cygwin32 += DLPORTIO PlxApi setupapi
xxx_LIBS_WIN32        += DLPORTIO PlxApi
xxx_SYS_LIBS_WIN32    += setupapi
# This is needed by saveData and asyn VXI-11 on cygwin
xxx_SYS_LIBS_cygwin32 += rpc


#===========================

include $(TOP)/configure/RULES
#----------------------------------------
#  ADD RULES AFTER THIS LINE
