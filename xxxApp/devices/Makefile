TOP=../..
include $(TOP)/configure/CONFIG

# Assemble the shared, IOC-agnostic device type library from the type snippets
# in this directory and install it to the top-level devices/ directory (the
# custom DEVICES file type, see configure/CONFIG_SITE).
#
# The output name is prefixed with a number because assembleSnippets.pl only
# accepts snippet files whose basename starts with a digit; each IOC's
# per-IOC assembly consumes this file as a snippet, so it must be numbered.
# The "10_" rank also places the type library after per-IOC globals (00_) and
# before per-IOC instances (50_+) in the final per-IOC assembly.
#
# The *.yml pattern catches only the type snippets: assembleSnippets.pl ignores
# any file whose basename does not start with a digit, so Makefile and
# README.md are not swept in.
COMMON_ASSEMBLIES          += 00_device_templates.yml
00_device_templates.yml_PATTERN       += *.yml

DEVICES += 00_device_templates.yml

include $(TOP)/configure/RULES

# Bridge the assembled output (in $(COMMON_DIR)/O.Common) to the DEVICES
# install rule, which looks for its source relative to the build directory.
vpath %.yml $(COMMON_DIR)
