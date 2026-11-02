TOP = ../..
include $(TOP)/configure/CONFIG

# Uncomment to set ARCH manually for cross-compiles, 
# otherwise leave as EPICS_HOST_ARCH

#ARCH = linux-arm
#ARCH = vxWorks-ppc32
#ARCH = vxWorks-ppc32sf

ARCH ?= $(EPICS_HOST_ARCH)

TARGETS = cdCommands envPaths dllPath.bat modules.lua

include $(TOP)/configure/RULES.ioc
