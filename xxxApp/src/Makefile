TOP=../..

include $(TOP)/configure/CONFIG
#----------------------------------------
#  ADD MACRO DEFINITIONS AFTER THIS LINE
#=============================

# For Kate Feng's implementation of devScaler.c, which uses Till
# Straumann's basicIoOps.h to bridge any mismatch between endianness
# of Joerger scaler hardware and endianness of processor.
#USR_CFLAGS += -DHAS_IOOPS_H

# Locally built ca-client application
#PROD_HOST += caExample
#caExample_SRCS	+= caExample.c
#caExample_LIBS	+= ca
#caExample_LIBS	+= Com
#ca_DIR           = $(EPICS_BASE_LIB)
#Com_DIR          = $(EPICS_BASE_LIB)


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

PROD_IOC_vxWorks = xxx

# <name>.dbd will be created from <name>Include.dbd
DBD += xxx.dbd
DBD += xxxVX.dbd

# <name>_registerRecordDeviceDriver.cpp will be created from <name>.dbd
xxx_SRCS_DEFAULT += xxx_registerRecordDeviceDriver.cpp
xxx_SRCS_vxWorks += xxxVX_registerRecordDeviceDriver.cpp

xxx_SRCS_DEFAULT += xxxMain.cpp
xxx_SRCS_vxWorks += -nil-

# The following builds xxxSNL as a component of xxx
# NOTE: for suffix .st, code is run through cpp; for .stt, it's not
#xxx_SRCS += xxxSNL.st
#xxx_SRCS_vxWorks += xxxSNL.st

#xxx_LIBS += xxxSupport

### from support
xxx_LIBS_DEFAULT += mca mcaCanberra mcaSIS
xxx_LIBS_solaris += -nil-
mca_DIR = $(MCA_LIB)
mcaCanberra_DIR = $(MCA_LIB)
mcaSIS_DIR = $(MCA_LIB)

xxx_LIBS_DEFAULT += dac128V
xxx_LIBS_solaris += -nil-
dac128V_DIR = $(DAC128V_LIB)

xxx_LIBS_DEFAULT += gpib
xxx_LIBS_solaris += gpib
gpib_DIR = $(GPIBCORE_LIB)

xxx_LIBS_DEFAULT += ip
xxx_LIBS_solaris += -nil-
ip_DIR = $(IP_LIB)

xxx_LIBS_DEFAULT += ip330 devIp330
xxx_LIBS_solaris += -nil-
ip330_DIR = $(IP330_LIB)
devip330_DIR = $(IP330_LIB)

xxx_LIBS_DEFAULT += ipUnidig
xxx_LIBS_solaris += -nil-
ipUnidig_DIR = $(IPUNIDIG_LIB)

xxx_LIBS_DEFAULT += love
xxx_LIBS_solaris += -nil-
love_DIR = $(LOVE_LIB)

xxx_LDOBJS_vxWorks += $(IPAC_BIN)/ipacLib
xxx_OBJS_vxWorks += $(IPAC_BIN)/tyGSOctal

xxx_LIBS_DEFAULT += oms softMotor motor
xxx_LIBS_solaris += softMotor motor
motor_DIR = $(MOTOR_LIB)
softMotor_DIR = $(MOTOR_LIB)
oms_DIR = $(MOTOR_LIB)

xxx_LIBS_DEFAULT += seq pv seqDev
xxx_LIBS_solaris += seq pv seqDev
seq_DIR = $(SEQ_LIB)
pv_DIR = $(SEQ_LIB)
seqDev_DIR = $(SEQ_LIB)

#xxx_LIBS_DEFAULT += vxStats
#xxx_LIBS_solaris += BSlib
#vxStats_DIR = $(VXSTATS_LIB)
#BSlib_DIR = $(VXSTATS_LIB)

xxx_LIBS += std
std_DIR = $(STD_LIB)

xxx_LIBS += mpf mpfEpics mpfSerial
mpf_DIR = $(MPF_LIB)
mpfEpics_DIR = $(MPF_LIB)
mpfSerial_DIR = $(MPF_LIB)

### from base
xxx_LIBS += $(EPICS_BASE_IOC_LIBS)
# The following adds support from base/src/vxWorks
xxx_OBJS_vxWorks += $(EPICS_BASE_BIN)/vxComLibrary

#===========================

include $(TOP)/configure/RULES
#----------------------------------------
#  ADD RULES AFTER THIS LINE
