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

LIBRARY_IOC += xxxSupport

# xxxRecord.h will be created from xxxRecord.dbd
#DBDINC += xxxRecord
# install support-library .dbd into <top>/dbd
#DBD += xxxSupport.dbd

# The following are compiled and added to the Support library
#xxxSupport_SRCS += xxxRecord.c

#xxxSupport_LIBS += $(EPICS_BASE_IOC_LIBS)

#=============================
# build an ioc application

PROD_IOC = xxx

# <name>.dbd will be created from <name>Include.dbd
DBD += iocxxx.dbd
DBD += iocxxxVX.dbd

# <name>_registerRecordDeviceDriver.cpp will be created from <name>.dbd
xxx_SRCS_DEFAULT += iocxxx_registerRecordDeviceDriver.cpp
xxx_SRCS_vxWorks += iocxxxVX_registerRecordDeviceDriver.cpp

xxx_SRCS_DEFAULT += xxxMain.cpp
xxx_SRCS_vxWorks += -nil-

# The following builds xxxSNL as a component of xxx
# NOTE: for suffix .st, code is run through cpp; for .stt, it's not
#xxx_SRCS += xxxSNL.st
#xxx_SRCS_vxWorks += xxxSNL.st

#xxx_LIBS += xxxSupport

### from support
xxx_LIBS += mca 
# Convert the following line to XXX_LIBS_vxWorks if you are not building mcaCanberra
# for the host
xxx_LIBS += mcaCanberra 
xxx_LIBS_vxWorks += mcaSIS

xxx_LIBS_vxWorks += dac128V

xxx_LIBS += ip

xxx_LIBS_vxWorks += ip330 devIp330

xxx_LIBS_vxWorks += ipUnidig

xxx_LIBS_vxWorks += quadEM

xxx_LIBS_vxWorks += dxp xerxes
xxx_LIBS_Linux += dxp xerxes

xxx_LIBS_vxWorks += love

xxx_LIBS += motor softMotor
xxx_LIBS += Acs Ims Mclennan motorCOM_mpf Newport
xxx_LIBS_vxWorks += oms 

#xxx_LIBS_vxWorks += vxStats

xxx_LIBS += std

xxx_LIBS += mpfSerial mpf mpfEpics

xxx_LIBS += seq pv seqDev

#xxx_LIBS += gpib

xxx_LIBS_vxWorks += allenBradley

# xxx: in switch from ipac-2_5 to ipac-2_6,
# $(IPAC_BIN)/tyGSOctal became $(IPAC_LIB)/libTyGSOctal.a, and
# $(IPAC_BIN)/ipacLib became $(IPAC_LIB)/libIpac.a
xxx_LIBS_vxWorks += TyGSOctal Ipac
#xxx_LDOBJS_vxWorks += $(IPAC_BIN)/ipacLib
#xxx_OBJS_vxWorks += $(IPAC_BIN)/tyGSOctal

### from base
xxx_LIBS += $(EPICS_BASE_IOC_LIBS)
# The following adds support from base/src/vxWorks
xxx_OBJS_vxWorks += $(EPICS_BASE_BIN)/vxComLibrary

#===========================

include $(TOP)/configure/RULES
#----------------------------------------
#  ADD RULES AFTER THIS LINE
