
# BEGIN save_restore.cmd ------------------------------------------------------

# This file does not require modification for standard use, other than to
# specify the prefix.  However...
# If you want save_restore to manage its own NFS mount, specify the name and
# IP address of the file server to which save files should be written, and
# call set_savefile_path() with a path as the server sees it.  This currently
# is supported only on vxWorks.
# If the NFS mount from nfsCommands is used, call set_savefile_path() with a
# path as mounted by that file

# That is, do this...
#set_savefile_path(startup, "autosave")

# ... or this...
save_restoreSet_NFSHost("oxygen", "164.54.22.10")
set_savefile_path("/export/oxygen4/MOONEY/epics/synApps/support/xxx/iocBoot/iocvxWorks", "autosave")

# status PVs: default is to use them
#save_restoreSet_UseStatusPVs(1)
save_restoreSet_status_prefix("xxx:")
dbLoadRecords("$(AUTOSAVE)/asApp/Db/save_restoreStatus.db", "P=xxx:, DEAD_SECONDS=5")

# Ok to save/restore save sets with missing values (no CA connection to PV)?
save_restoreSet_IncompleteSetsOk(1)

# Save dated backup files?
save_restoreSet_DatedBackupFiles(1)

# Number of sequenced backup files to write
save_restoreSet_NumSeqFiles(3)

# Time interval between sequenced backups
save_restoreSet_SeqPeriodInSeconds(300)

# Ok to retry connecting to PVs whose initial connection attempt failed?
save_restoreSet_CAReconnect(1)

# Time interval in seconds between forced save-file writes.  (-1 means forever).
# This is intended to get save files written even if the normal trigger mechanism is broken.
save_restoreSet_CallbackTimeout(-1)

###
# specify what save files should be restored.  Note these files must be
# in the directory specified in set_savefile_path(), or, if that function
# has not been called, from the directory current when iocInit is invoked
set_pass0_restoreFile("auto_positions.sav")
# Note doAfterIocInit() supplied by std module.
doAfterIocInit("create_monitor_set('auto_positions.req',5,'P=xxx:')")

set_pass0_restoreFile("auto_settings.sav")
set_pass1_restoreFile("auto_settings.sav")
doAfterIocInit("create_monitor_set('auto_settings.req',30,'P=xxx:')")

# Note that you can restore a .sav file without also autosaving to it.
#set_pass0_restoreFile("octupole_settings.sav")
#set_pass1_restoreFile("octupole_settings.sav")

###
# specify directories in which to search for included request files
# Note that the vxWorks variables (e.g., 'startup') are from cdCommands
set_requestfile_path(startup, "")
set_requestfile_path(startup, "autosave")
set_requestfile_path(adcore, "ADApp/Db")
set_requestfile_path(autosave, "asApp/Db")
set_requestfile_path(busy, "busyApp/Db")
set_requestfile_path(calc, "calcApp/Db")
set_requestfile_path(camac, "camacApp/Db")
set_requestfile_path(caputrecorder, "caputRecorderApp/Db")
set_requestfile_path(dac128v, "dac128VApp/Db")
set_requestfile_path(delaygen, "delaygenApp/Db")
set_requestfile_path(dxp, "dxpApp/Db")
set_requestfile_path(ip, "ipApp/Db")
set_requestfile_path(ip330, "ip330App/Db")
set_requestfile_path(ipunidig, "ipUnidigApp/Db")
set_requestfile_path(love, "loveApp/Db")
set_requestfile_path(mca, "mcaApp/Db")
set_requestfile_path(meascomp, "measCompApp/Db")
set_requestfile_path(modbus, "modbusApp/Db")
set_requestfile_path(motor, "motorApp/Db")
set_requestfile_path(optics, "opticsApp/Db")
set_requestfile_path(quadem, "quadEMApp/Db")
set_requestfile_path(softglue, "softGlueApp/Db")
set_requestfile_path(sscan, "sscanApp/Db")
set_requestfile_path(std, "stdApp/Db")
set_requestfile_path(vac, "vacApp/Db")
set_requestfile_path(vme, "vmeApp/Db")
set_requestfile_path(top, "xxxApp/Db")

# Debug-output level
save_restoreSet_Debug(0)

# Tell autosave to automatically build built_settings.req and
# built_positions.req from databases and macros supplied to dbLoadRecords()
# (and dbLoadTemplate(), which calls dbLoadRecords()).
# This requires EPICS 3.15.1 or later, or 3.14 patched as described in
# autosave R5-5 documentation.
epicsEnvSet("BUILT_SETTINGS", "built_settings.req")
epicsEnvSet("BUILT_POSITIONS", "built_positions.req")
autosaveBuild("$(BUILT_SETTINGS)", "_settings.req", 1)
#autosaveBuild("$(BUILT_SETTINGS)", ".req", 1)
autosaveBuild("$(BUILT_POSITIONS)", "_positions.req", 1)

# END save_restore.cmd --------------------------------------------------------
