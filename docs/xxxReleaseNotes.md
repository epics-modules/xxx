---
layout: default
title: Release Notes
nav_order: 3
---


xxx Release Notes
=================

Release 6-4
-----------

### IOC Management

* Renamed `xxx.pl` to `ioc.pl` -- the launcher script no longer needs to match the IOC name
* Display manager launch commands (`medm`, `caqtdm`, `phoebus`) moved from top-level start scripts into the softioc commands directory, making each IOC directory fully self-contained
* Removed `start_MEDM_xxx`, `start_caQtDM_xxx`, `start_phoebus_xxx` top-level scripts -- use `ioc.pl medm`, `ioc.pl caqtdm`, `ioc.pl phoebus` instead
* Removed legacy `run` and `in-screen.sh` scripts -- use `ioc.pl start` / `ioc.pl screen start` instead
* Display-related environment variables (`IOC_DEFAULT_ADL`, `IOC_DEFAULT_UI`, `IOC_DEFAULT_BOB`, `IOC_DEFAULT_MACROS`) now set automatically in `ioc.pl` based on `IOC_NAME`
* Added stale procServ info file detection with user prompt when starting an IOC; validates via PID check (same host) or TCP connect (remote host)
* Added 5-second timeout to procServ TCP connections to prevent hangs on unreachable hosts
* Fixed procServ `-I` info file written to wrong directory when using symlinks (GitHub issue #74) -- now uses absolute paths
* Added log file size watcher that truncates console log files when they exceed a configurable maximum (default 1 GB), keeping the most recent content
* Creating a second IOC from the template now requires only: copy the `iocBoot/iocxxx` directory, edit `IOC_NAME` in `settings.iocsh`, and run `make`

### Display Path Setup

* `setup_epics_common` rewritten in Perl with automatic screen directory discovery -- no longer requires manually listing each module's screen path
* Screen directories are discovered by scanning all modules from `configure/RELEASE` using a depth-limited search
* `modules/` subdirectories (e.g., motor submodules) are automatically searched
* `autoconvert/` directories are automatically appended when screen files are found
* Performance optimized: depth-limited search completes in under 3 seconds vs ~20 seconds for full recursive scan

### Gestalt Screens

* Completed the gestalt data file (`xxx.yml`) to match all entries from the hand-crafted caQtDM screen
* Fixed bugs in the gestalt data: MLL motor file/count mismatch, Slit #2 copy-paste errors, Table3/Table4 macro errors, Shutter file mismatch, ADGeniCam BlackflyS typo
* Added all previously missing entries: Direct I/O tab (12 entries), Devices tab (13 entries), Tools tab (11 entries), Detectors tab (8 entries), Motors tab (3 entries)
* Added Status/APS Ops bar below the tabbed group
* Layout updated to use `TabbedRepeat` for user-customizable tabs with 5-column grid

### areaDetector Examples

* Standardized all 19 detector example scripts to use hardcoded `Image1` port name for NDStdArrays (reverted from `$(INSTANCE)Image` convention)
* Fixed ADDexela: NDStdArraysConfigure port name mismatch that broke the image plugin
* Fixed ADGeniCam: `$(PORT)` changed to `$(INSTANCE)` in ADVimbaConfig and asynSetTraceIOMask
* Fixed ADMarCCD: `mar345Config` changed to `marCCDConfig` (copy-paste error)
* Fixed ADEiger1X/2X: header comment TYPE default corrected from Int32 to Int8
* Fixed ADAdsc: added missing `set_requestfile_path`
* Added COLORS support to ADProsilica for color camera modes
* Added type-aware `EPICS_CA_MAX_ARRAY_BYTES` calculation to all 19 scripts (1.1x image size in bytes)
* Cleaned up stale comments referencing simDetector in 12 scripts

### Serial Device Examples

* Added 22 new device examples to `serial_devices.iocsh` from synApps ip and love modules
* New devices include: ADAM 4018, Agilent E3631A, BK 9130, Eurotherm 2000-series, LakeShore 218/330/340, Love controllers, MKS 651C, Newport LAE500, Omega DP41, Oxford CS800, Pelco CM6700, Protura P201, SRS PTC10 (Ethernet with RTD/TC/TEC channels), SR830, US Digital X3
* Updated Eurotherm entry from old `dbLoadRecords` to new `Eurotherm2k.iocsh`
* Parameter values sourced from module authors' own example IOCs

### Other

* Added PVA server registration and core library linking
* Added PVAlive database and QSRV group
* Added BLEPS databases
* Added motorAcsMotion support
* Added PI GCS2 support
* Disabled EPICS base 7.0.8 iocsh history file by default
* Fixed remote command triggering on certain computers
* Various Windows compatibility fixes for procServ/screen commands

Release 6-3
-----------

* Added Scaler module
* Added LabJack module
* Added Xpress3 module
* Added Galil module
* vxWorks IOCs now automatically write out their bootParams on a successful boot
* xxx startup script converted to perl for cross-platform compatibility
* xxx startup script also no longer needs IOC_STARTUP_DIR to be set
* New AreaDetector example scripts
* Autosave .req search path automatically generated based on RELEASE file

Release 6-2-1
-------------

*   Adjustments for scaler code being broken out from std module

Release 6-2
-----------

*   Parts of common.iocsh that were likely to be changed moved out to settings.iocsh

Release 6-1
-----------

*   autsaveBuild files are now built in the autosave directory so that the primary iocxxx directory doesn't need to be open to be written by anyone.
*   xxx.adl screen updated to match tab-style design of the .ui file.

Release 6-0
-----------

*   Added lua scripting module
*   Added SoftGlueZynq module
*   Added Yokogawa DAU module
*   Added dxpSitoro module
*   iocBoot/iocvxWorks, iocBoot/iocLinux, etc: Condensed into single iocxxx directory
*   st.cmd.Linux, st.cmd.vxWorks, etc: Individual startup scripts provided for each architecture
*   All startup scripts using iocsh to eliminate most architectural differences
*   Startup scripts rewritten to use iocshLoad capabilities of base-3.15
*   xxx.ui updated to take full advantage of caQtDm widgets
*   xxxApp/src/Makefile greatly simplified
*   release.pl modified to fix an issue where it wasn't checking optional includes
*   softioc startup script now includes options to start medm and caQtDM
*   MEDM and caQtDM startup scripts cleaned up

Release 5-8-3
-------------

*   Changes to support caputRecorder
*   Added GROUP env var for alive record
*   release.pl modified so that module definitions are processed in the order they occur. This allows, for example, the following:
    
    include $(SUPPORT)/configure/RELEASE
    CAPUTRECORDER=$(SUPPORT)/caputRecorder-1-4-2
    
    in which the CAPUTRECORDER definition overrides the definition in $(SUPPORT)/configure/RELEASE

Release 5-8
-----------

*   Deleted xxxCommonInclude.dbd since it is no longer used.
*   Many changes for areaDetector-2-0
*   Use the alive module
*   Added xxx.sh, a script to start/stop/restart a linux ioc in a screen session. Improved in-screen.sh and run scripts.
*   Rewrote xxxApp/src/Makefile: .dbd users must come after sources, so required stuff is defined before it is used, but .lib users must come before sources, so required references are encountered before a library is searched. Added ifdefs for ETHERIP, ALIVE, DELAYGEN, and VAC modules.
*   New configure/CONFIG from 3.14.12.4 makeBaseApp
*   start\_caQtDM: Added drag-and-drop workaround for caQtDM.
*   iocBoot/iocvxWorks, iocLinux: Changed many .cmd files to use doAfterIocInit. Added commented out examples of using autosaveBuild. (AutosaveBuild requires either base 3.15.1, or a patched copy of base 3.14.12.)
*   iocBoot/iocvxWorks/softGlue.cmd: Example of registered interrupt service routine.
*   iocBoot/ioc\*/calc.cmd: new file
*   xxxApp/src/Makefile: changes to build with 3.15
*   Many changes to use caputRecorder

Release 5-7-1
-------------

*   iocBoot/iocLinux: new filter.substitutions from optics, added async\_pid\_slow.substitutions, scan1Menu.req
*   iocBoot/iocvxWorks: new filter.substitutions from optics

Release 5-7
-----------

*   string sequence records moved from std to calc module
*   Added .ui files for caQtDM
*   rewrote xxxApp/src/Makefile to build dbd file and specify link libraries according to what modules are defined in configure/RELEASE
*   SIS38xx setup changed for mca-7-3-1
*   Added configMenu for softGlue and scans.
*   Added support for async\_pid\_slow, new XIA filter software
*   Deleted vxStats (replaced by devIocStats)

Release 5-6
-----------

*   Include areaDetector, dxp, modbus, softGlue
*   configure/RELEASE changes
*   CSS-BOY displays and .def files
*   start\_epics for bash, setup\_epics improvements
*   Added op/burt directory for interp, softGlue
*   vxStats replaced by devIocStats
*   Many changes to match new or modified features in external modules.

Release 5-5
-----------

*   Added busy module, deleted ccd and pilatus modules
*   Deleted iocxxxCygwinInclude.dbd, iocxxxWin32Include.dbd, iocxxx\_solarisInclude.dbd -- build the targets in Makefile instead.
*   .dbd file changes to agree with synApps 5.5 module choices
*   Additions for areaDetector
*   added multilayer mono, FuncGen, softGlue to xxx.adl

Release 5-4
-----------

*   Build modified to agree with 3.14.10 version of makeBaseApp.pl
*   Use of genSub module replaced by use of aSub record from base 3.14.10.
*   Use new busy module.
*   iocSolaris: Added databases Io.db, ramp\_tweak.db, pvHistory.db; must use 'var' to define variable

Release 5-3
-----------

*   xxx/release.pl: Bug fix; "($macro) =" line was wrong. Support "include" entries without a macro.
*   xxx/iocBoot/ioc\*/\*.substitutions: 3.14.9 will require macros in substitution files to be enclosed in quotes. Start now, since it's already legal.
*   xxx/iocBoot/iocCygwin/saveData.req: added basename section
*   xxx/iocBoot/ioc\*: Some databases and autosave-request files in synApps have been renamed so that the autosave-request file name can be autogenerated easily from the database name, e.g.: .db <--> \_settings.req. This will permit utils/makeAutosaveFiles.py to work more comprehensively.
*   xxx/iocBoot/ioc\*/save\_restore.cmd: Added modbus, pilatus, and vac to requestfile path; Added call to save\_restoreSet\_UseStatusPVs()
*   xxx/iocBoot/ioc\*/st.cmd: scans.db was split into standardScans.db and saveData.db, so it's easier to load multiple scan databases.
*   xxx/iocBoot/ioc\*/interp\_settings.req: moved to calc module (and modified there to agree with current interp database).
*   unlisted changes in the build files to agree with changes in synApps.

Release 5-2
-----------

*   iocBoot/iocCygwin/\* -- Added examples for loading databases, specifying autosave PV's, and invoking SNL programs, for orientation matrix, femto amplifier, and pf4dual slit.
    
*   pseudoMotor.db, sumDiff2D.db, and coordTrans2D.db are now in the motor module, and not in xxx. This affects some substitution files in iocBoot/ioc\*.
    
*   Some synApps databases used to specify input/output message terminators, and no longer do this. Message terminators must be specified in serial.cmd.
    
*   Added examples for userArrayCalcs, pvHistory, XIA slit, string sequence, timer
    
*   Specified message terminators for Digitel in serial.cmd
    
*   Added example of setting system clock rate to iocvxWorks/st.cmd
    
*   Added new motor types to xxxApp/src/\*
    
*   Scaler database loading has changed to accommodate asyn-based device support.
    
*   Modified substitutions files in iocBoot/ioc\* to enclose in quotes any macro substitutions that themselves contain macro arguments (i.e., X=$(Y) -> X="$(Y)"). This will be required in EPICS 3.14.9.

Release 5-1
-----------

*   Fixes to run from support directory on the gateway.
    
*   MPF is out; asyn is in
    
*   Don't need to specify handshake PV in saveData.req. It's now hardwired into saveData.
    
*   Split out many .cmd files from st.cmd
    
*   Multi-element mca setup now in device-specific files
    
*   Serial/GPIB config now in asynRecord.template, serial.cmd
    
*   serial\_OI\_Block, GPIB\_OI\_Block -> deviceCmdReply
    


Release 5-0
-----------

*   start\_epics\_xxx - added new modules to EPICS\_DISPLAY\_PATH. Added specification of EPICS\_CA\_MAX\_ARRAY\_BYTES
    
*   documentation/vme\_address.html - table of VME addresses, interrupt vectors, etc.
    
*   iocxxx - split into iocUnix, iocvxWorks
    
*   st.cmd, xxxApp/src - changed xxx.dbd to iocxxx.dbd, xxx\_registerRecordDeviceDriver to iocxxx\_registerRecordDeviceDriver because c function name cannot begin with a number
    
*   st1.cmd - cd to topbin/../vxWorks-68040, so we don't have to have a separate cdCommands file. Load xxx.munch instead of a bunch of separate files
    
*   st1.cmd - must configure dac before ip330PID
    
*   vxStats.substitutions - new file to work with vxStats module
    
*   pid\*.substitutions, dac128V.substitutions - new files
    
*   xxx.adl - added vxStats, Keithley 2000; changes in mca, DAC
    

Suggestions and Comments to:  
[Keenan Lang](mailto:klang@anl.gov) : (klang@anl.gov)  
