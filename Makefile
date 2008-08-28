#Makefile at top of application tree
TOP = .
include $(TOP)/configure/CONFIG

DIRS += configure xxxApp iocBoot
xxxApp_DEPEND_DIRS  = configure
iocBoot_DEPEND_DIRS = xxxApp

include $(TOP)/configure/RULES_TOP
