---
layout: default
title: Configuring an IOC
nav_order: 3
---


Configuring and Running a synApps IOC
=====================================

This page covers how to configure and run an IOC built from the xxx template. For an overview of the xxx module's file structure and build system, see the [Overview](overview.html). For obtaining and building synApps, see the [synApps documentation](https://epics-synapps.github.io/support/).


Setting up the IOC
------------------

**Linux soft IOC (typical deployment):**

Most synApps IOCs are deployed as Linux soft IOCs. The xxx module includes a `softioc/` directory with the `ioc.pl` script for managing the IOC under `procServ` or `screen`. Common commands:

```
cd iocBoot/iocxxx
softioc/ioc.pl start       # Start the IOC in the background
softioc/ioc.pl status      # Check if the IOC is running
softioc/ioc.pl console     # Connect to the running IOC's console
softioc/ioc.pl stop        # Stop the IOC
```

To run the IOC directly in the foreground:

```
cd iocBoot/iocxxx
../../bin/linux-x86_64/xxx st.cmd.Linux
```

Ensure that `caRepeater` is running on the host (it is started automatically by most Channel Access clients).

**vxWorks IOC:**

For vxWorks-based VME IOCs, see [vxWorks Configuration](https://epics-synapps.github.io/support/vxWorks.html) for boot parameter setup, serial console configuration, and NFS file system requirements.


Configuring hardware
--------------------

Hardware configuration is done in the IOC's `iocBoot/iocxxx/` directory. The key files are:

- `st.cmd.*` -- The IOC's startup script. It loads an executable, configures hardware, and loads databases from synApps modules. Mostly, it sources `.iocsh` files that do these same things. See the [Overview](overview.html) for details on the startup script structure.
- `settings.iocsh` -- Defines environment variables commonly used throughout the IOC, including the IOC name/prefix.
- `examples/*.iocsh` -- Example command files for common hardware (motors, serial devices, optics, detectors, etc.). Copy the relevant examples to the main `iocBoot/iocxxx/` directory and edit them to match your hardware, then add a line in `st.cmd` to source them.
- `examples/substitutions/*.substitutions` -- Example substitution files for database loading.
- `auto_positions.req`, `auto_settings.req` -- Autosave request files (see [autosave/restore](#autosaverestore) below).
- `saveData.req` -- Configuration for the saveData scan-data writer (see [saveData](#savedata) below).

**Motors** -- Motor configuration is done through substitution files and startup scripts. See the [motor module documentation](https://epics-modules.github.io/motor/) for details. In the xxx template, motor examples are at `iocBoot/iocxxx/examples/motors.iocsh` and `iocBoot/iocxxx/examples/substitutions/motor.substitutions`.

**Slits, optical tables, monochromators, filters** -- These optics devices are configured through database loading and SNL programs in the IOC startup scripts. See the [optics module documentation](https://epics-modules.github.io/optics/) for detailed usage of slit (`2slit.db`), table (`table.db`), monochromator (`kohzuSeq.db`, `hrSeq.db`, `SGM.db`, `ml_monoSeq.db`), and filter (`pf4`, `filterMotor.db`) databases and displays. Examples are in `iocBoot/iocxxx/examples/optics.iocsh`.

**Serial and GPIB devices** -- See the [ip module documentation](https://epics-modules.github.io/ip/) and [asyn documentation](https://epics-modules.github.io/asyn/). Examples are in `iocBoot/iocxxx/examples/serial_devices.iocsh` and `iocBoot/iocxxx/examples/gpib.iocsh`.

**Area detectors** -- See the [areaDetector documentation](https://areadetector.github.io/areaDetector/index.html). Examples are in `iocBoot/iocxxx/examples/detectors/`.

synApps also includes many features for run-time programming, including userCalcs, string and array expression evaluation, scan support, sequence records, signal averaging, interpolation, and FPGA-based digital logic. See the [calc](https://epics-modules.github.io/calc/), [sscan](https://epics-modules.github.io/sscan/), and [std](https://epics-modules.github.io/std/) module documentation for details.


Display managers
----------------

synApps includes display files in several formats: `.ui` files for caQtDM, `.bob` files for Phoebus, and `.adl` files for MEDM. The caQtDM `.ui` files are the primary, actively tested display files. Phoebus `.bob` files are also well-supported. The MEDM `.adl` files are still included but MEDM itself is a legacy tool.

- **caQtDM** (primary) -- Display files use the `.ui` format and are located in each module's `op/ui/` directory. All synApps display files are operationally tested in caQtDM.

    To start the caQtDM interface, edit and run the `start_caQtDM_xxx` script in your IOC directory (or use `softioc/ioc.pl caqtdm`). This script sets the environment variables `EPICS_APP` and `EPICS_APP_UI_DIR` and generates the display file search path from the application's `configure/RELEASE` file. For example:

    ```
    export EPICS_APP=/path/to/your/ioc
    export EPICS_APP_UI_DIR=${EPICS_APP}/xxxApp/op/ui
    ```

- **Phoebus** -- Phoebus `.bob` display files are also provided and well-supported. To start Phoebus with synApps displays, edit and run the `start_phoebus_xxx` script (or use `softioc/ioc.pl phoebus`).

- **MEDM** (legacy) -- The original MEDM `.adl` display files are still included and can be used with the `start_MEDM_xxx` script (or `softioc/ioc.pl medm`), but MEDM is no longer actively developed or the focus of testing.

If you are running a display manager on a workstation that isn't on the same subnet as the IOCs, you may need to set the environment variable `EPICS_CA_ADDR_LIST` to the IP addresses or broadcast addresses of the subnets containing the IOCs. With EPICS base 7.0 and PV Access, many of the old Channel Access array size limitations (`EPICS_CA_MAX_ARRAY_BYTES`) are no longer relevant when using PVA clients.


autosave/restore
----------------

The autosave directory (`iocBoot/iocxxx/autosave/`) must be writable by the IOC process so it can write the files `auto_positions.sav` and `auto_settings.sav`. On Linux, ensure the IOC user has write permission:

```
chmod a+w,g+s autosave
```

To modify the list of PVs that are saved and restored, edit `iocBoot/iocxxx/auto_settings.req` and `iocBoot/iocxxx/auto_positions.req`. Alternatively, you can use [autosaveBuild](https://epics-modules.github.io/autosave/) to have these files constructed automatically during the boot process.

The autosave software is started by the `create_monitor_set(...)` calls in `common.iocsh`. Restore happens during `iocInit` via initHooks in the autosave module.


saveData
--------

saveData is a Channel Access client that monitors sscan records and saves scan data to disk. It is configured with the file `iocBoot/iocxxx/saveData.req`, which specifies which sscan records to monitor and which PV values to include in all data files. Look for the `[extraPV]` section in `saveData.req` to customize the list of PVs saved with every data file. See the [sscan module documentation](https://epics-modules.github.io/sscan/) for details on saveData configuration and the MDA file format.
