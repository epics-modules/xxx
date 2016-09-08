
# BEGIN save_restore.cmd ------------------------------------------------------

# This file does not require modification for standard use
# If you want save_restore to manage its own NFS mount, specify the name and
# IP address of the file server to which save files should be written, and
# set SAVE_PATH to a path as the server sees it.  This currently
# is supported only on vxWorks.

#save_restoreSet_NFSHost("oxygen", "164.54.22.10")

iocshLoad("$(AUTOSAVE)/iocsh/autosave_settings.iocsh", "PREFIX=$(PREFIX), SAVE_PATH=$(TOP)/iocBoot/$(IOC)")
iocshLoad("$(AUTOSAVE)/iocsh/autosaveBuild.iocsh",     "PREFIX=$(PREFIX)")
iocshLoad("$(AUTOSAVE)/iocsh/save_restore.iocsh",      "PREFIX=$(PREFIX), POSITIONS_FILE=auto_positions, SETTINGS_FILE=auto_settings")

# Note that you can restore a .sav file without also autosaving to it.
#set_pass0_restoreFile("octupole_settings.sav")
#set_pass1_restoreFile("octupole_settings.sav")

###
# specify directories in which to search for included request files
# Note that the vxWorks variables (e.g., 'startup') are from cdCommands
set_requestfile_path("$(TOP)/iocBoot/$(IOC)/$(PLATFORM)", "")
set_requestfile_path("$(TOP)/iocBoot/$(IOC)/common", "")
set_requestfile_path("$(AREA_DETECTOR)", "ADApp/Db")
set_requestfile_path("$(ADCORE)", "ADApp/Db")
set_requestfile_path("$(AUTOSAVE)", "asApp/Db")
set_requestfile_path("$(BUSY)", "busyApp/Db")
set_requestfile_path("$(CALC)", "calcApp/Db")
set_requestfile_path("$(CAMAC)", "camacApp/Db")
set_requestfile_path("$(CAPUTRECORDER)", "caputRecorderApp/Db")
set_requestfile_path("$(DAC128V)", "dac128VApp/Db")
set_requestfile_path("$(DELAYGEN)", "delaygenApp/Db")
set_requestfile_path("$(DXP)", "dxpApp/Db")
set_requestfile_path("$(IP)", "ipApp/Db")
set_requestfile_path("$(IP330)", "ip330App/Db")
set_requestfile_path("$(IPUNIDIG)", "ipUnidigApp/Db")
set_requestfile_path("$(LOVE)", "loveApp/Db")
set_requestfile_path("$(MCA)", "mcaApp/Db")
set_requestfile_path("$(MEASCOMP)", "measCompApp/Db")
set_requestfile_path("$(MODBUS)", "modbusApp/Db")
set_requestfile_path("$(MOTOR)", "motorApp/Db")
set_requestfile_path("$(OPTICS)", "opticsApp/Db")
set_requestfile_path("$(QUADEM)", "quadEMApp/Db")
set_requestfile_path("$(SSCAN)", "sscanApp/Db")
set_requestfile_path("$(SOFTGLUE)", "softGlueApp/Db")
set_requestfile_path("$(STD)", "stdApp/Db")
set_requestfile_path("$(VAC)", "vacApp/Db")
set_requestfile_path("$(VME)", "vmeApp/Db")
set_requestfile_path("$(TOP)", "xxxApp/Db")

# Debug-output level
save_restoreSet_Debug(0)

# END save_restore.cmd --------------------------------------------------------
