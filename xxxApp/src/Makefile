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
DBD += iocxxx.dbd
DBD += iocxxxVX.dbd
DBD += iocxxx_solaris.dbd

# <name>_registerRecordDeviceDriver.cpp will be created from <name>.dbd
xxx_SRCS_DEFAULT += iocxxx_registerRecordDeviceDriver.cpp
xxx_SRCS_vxWorks += iocxxxVX_registerRecordDeviceDriver.cpp
xxx_SRCS_solaris += iocxxx_solaris_registerRecordDeviceDriver.cpp
xxx_SRCS_solaris += xxxMain.cpp

xxx_SRCS_DEFAULT += xxxMain.cpp
xxx_SRCS_vxWorks += -nil-

#xxx_Common_LIBS += xxxSupport
xxx_Common_LIBS += genSub
xxx_Common_LIBS += mca
xxx_Common_LIBS += calc
xxx_Common_LIBS += sscan
xxx_Common_LIBS += autosave
xxx_Common_LIBS += optics
xxx_Common_LIBS += vme
xxx_Common_LIBS += std
xxx_Common_LIBS += ip
#xxx_Common_LIBS += brukerCCD
#xxx_Common_LIBS += marCCD
#xxx_Common_LIBS += roperCCD
#xxx_Common_LIBS += Acs Ims Mclennan motor Newport softMotor
xxx_Common_LIBS += Acs motor Mclennan Newport softMotor
xxx_Common_LIBS += asyn
xxx_Common_LIBS += seq pv seqDev
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
xxx_vxWorks_LIBS += oms
#xxx_vxWorks_LIBS += love
xxx_vxWorks_LIBS += vxStats
xxx_vxWorks_LIBS += TyGSOctal Ipac
#The following adds support from base/src/vxWorks
xxx_OBJS_vxWorks += $(EPICS_BASE_BIN)/vxComLibrary

xxx_Linux_LIBS  += dxp handel
# If libnet IS installed on your HOST Linux system;
# uncomment the following line.
#xxx_Linux_LIBS  += mcaCanberra

xxx_solaris_LIBS += genSub
#xxx_solaris_LIBS += mca
xxx_solaris_LIBS += calc
xxx_solaris_LIBS += sscan
xxx_solaris_LIBS += autosave
xxx_solaris_LIBS += optics
#xxx_solaris_LIBS += vme
xxx_solaris_LIBS += std
#xxx_solaris_LIBS += ip
#xxx_solaris_LIBS += brukerCCD
#xxx_solaris_LIBS += marCCD
#xxx_solaris_LIBS += roperCCD
xxx_solaris_LIBS += motor softMotor
xxx_solaris_LIBS += asyn
xxx_solaris_LIBS += seq pv seqDev
xxx_solaris_LIBS += $(EPICS_BASE_IOC_LIBS)


xxx_LIBS_DEFAULT = $(xxx_Common_LIBS)
xxx_LIBS_vxWorks = $(xxx_vxWorks_LIBS) $(xxx_Common_LIBS)
xxx_LIBS_Linux   = $(xxx_Linux_LIBS)   $(xxx_Common_LIBS)
xxx_LIBS_solaris = $(xxx_solaris_LIBS)

# If the host has libnet and libpcap for mca/Canberra support
# uncomment the following line.
#xxx_SYS_LIBS_Linux += net pcap
xxx_SYS_LIBS_vxWorks += -nil-

#===========================

include $(TOP)/configure/RULES
#----------------------------------------
#  ADD RULES AFTER THIS LINE
