# Makefile
TOP=../..
include $(TOP)/configure/CONFIG
#----------------------------------------
#  ADD MACRO DEFINITIONS AFTER THIS LINE
#=============================

DBD += xxx.dbd
DBD += xxxVx.dbd

PROD_IOC_DEFAULT = xxx
PROD_IOC_vxWorks = xxxVx

xxx_SRCS   += xxx_registerRecordDeviceDriver.cpp
xxxVx_SRCS += xxxVx_registerRecordDeviceDriver.cpp
xxx_SRCS_DEFAULT += xxxMain.cpp

#The following adds support from base/src/vxWorks
xxxVx_OBJS_vxWorks += $(EPICS_BASE_BIN)/vxComLibrary

# Support from ipac
xxxVx_LDOBJS_vxWorks += $(IPAC_BIN)/ipacLib
xxxVx_OBJS_vxWorks   += $(IPAC_BIN)/tyGSOctal

# MCA libraries
xxxVx_LIBS += mcaSIS
xxxVx_LIBS += mcaCanberra
xxxVx_LIBS += mca

# IP libraries.
xxxVx_LIBS += ip

# IP330 libraries
xxxVx_LIBS += ip330
xxxVx_LIBS += devIp330

# STD libraries
xxx_LIBS   += std
xxxVx_LIBS += std
#xxxVx_OBJS_vxWorks += $(STD_BIN)/module_types.o

# MOTOR libraries
xxx_LIBS   += Newport softMotor motorCOM_mpf motor
xxxVx_LIBS += oms Newport softMotor motorCOM_mpf motor

# LOVE libraries
xxxVx_LIBS += love

# IPUNIDIG libraries
xxxVx_LIBS += ipUnidig

# DAC128V libraries
xxxVx_LIBS += dac128V

# MPF libraries.
xxx_LIBS   += mpfSerial mpfEpics mpf
xxxVx_LIBS += mpfSerial mpfEpics mpf

# SNCSEQ libraries.
xxx_LIBS   += seq pv
xxxVx_LIBS += seq pv

# Support from vxStats
xxxVx_OBJS_vxWorks   += $(VXSTATS_BIN)/devVXStats

xxx_LIBS   += $(EPICS_BASE_IOC_LIBS)
xxxVx_LIBS += $(EPICS_BASE_IOC_LIBS)

include $(TOP)/configure/RULES
#----------------------------------------
#  ADD RULES AFTER THIS LINE

