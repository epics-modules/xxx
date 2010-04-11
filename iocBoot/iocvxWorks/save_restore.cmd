
# BEGIN save_restore.cmd ------------------------------------------------------

### save_restore setup
#
# This file does not require modification for standard use, but...

# If you want save_restore to manage its own NFS mount, specify the name and
# IP address of the file server to which save files should be written, and
# call set_savefile_path() with a path as the server sees it.  This currently
# is supported only on vxWorks.
# If the NFS mount from nfsCommands is used, call set_savefile_path() with a
# path as mounted by that file
# That is, do this...
set_savefile_path(startup, "autosave")
# ... or this...
#save_restoreSet_NFSHost("oxygen", "164.54.52.4")
#set_savefile_path("/export/oxygen4/MOONEY/epics/synApps/support/xxx/iocBoot/iocvxWorks", "autosave")

# status PVs
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

###
# specify what save files should be restored.  Note these files must be
# in the directory specified in set_savefile_path(), or, if that function
# has not been called, from the directory current when iocInit is invoked
set_pass0_restoreFile("auto_positions.sav")
set_pass0_restoreFile("auto_settings.sav")
set_pass1_restoreFile("auto_settings.sav")

# Note that you can restore a .sav file without also autosaving to it.
#set_pass0_restoreFile("myInitData.sav")
#set_pass1_restoreFile("myInitData.sav")

###
# specify directories in which to search for included request files
set_requestfile_path(startup, "")
set_requestfile_path(startup, "autosave")
set_requestfile_path("$(AREA_DETECTOR)", "ADApp/Db")
set_requestfile_path(autosave, "asApp/Db")
set_requestfile_path(calc, "calcApp/Db")
set_requestfile_path(camac, "camacApp/Db")
set_requestfile_path(dac128v, "dac128VApp/Db")
set_requestfile_path(dxp, "dxpApp/Db")
set_requestfile_path(ip, "ipApp/Db")
set_requestfile_path(ip330, "ip330App/Db")
set_requestfile_path(ipunidig, "ipUnidigApp/Db")
set_requestfile_path(love, "loveApp/Db")
set_requestfile_path(mca, "mcaApp/Db")
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

# END save_restore.cmd --------------------------------------------------------
