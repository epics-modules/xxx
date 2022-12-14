TOP = ..
include $(TOP)/configure/CONFIG

ifeq ($(BUILD_IOCS), YES)
    DIRS := $(DIRS) $(filter-out $(DIRS), $(wildcard *src*))
    DIRS := $(DIRS) $(filter-out $(DIRS), $(wildcard *Src*))
endif

DIRS := $(DIRS) $(filter-out $(DIRS), $(wildcard *db*))
DIRS := $(DIRS) $(filter-out $(DIRS), $(wildcard *Db*))
DIRS := $(DIRS) $(filter-out $(DIRS), $(wildcard *op*))
include $(TOP)/configure/RULES_DIRS

