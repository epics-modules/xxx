TOP=../../..
include $(TOP)/configure/CONFIG

# Assemble this IOC's device file from the shared type library (00_device_templates.yml,
# installed to the top-level devices/ dir) plus the IOC's own snippets in this
# directory. The shared types snippet is rank 00, so anchors precede the instance 
# aliases that merge them.
#
# The output is installed into the top-level devices/ directory alongside the
# shared type library. The IOC name in the filename keeps it from colliding
# with the device files of other IOCs built from the same executable.


ifdef T_A

# Derive IOC name from parent directory
  IOC_DEVICES := $(notdir $(abspath ../..))_devices.yml

  ASSEMBLIES                      += $(IOC_DEVICES)
  $(IOC_DEVICES)_SNIPPETS         += $(INSTALL_DEVICES)/00_device_templates.yml
  $(IOC_DEVICES)_PATTERN          += *.yml

  DEVICES += $(IOC_DEVICES)
endif

include $(TOP)/configure/RULES
