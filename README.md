# xxx

XXX is a template for creating EPICS IOCs that provide beam line support
using the [synApps](https://github.com/BCDA-APS/synApps) module collection.

* [Documentation](https://epics-modules.github.io/xxx)
* [Report an issue](https://github.com/epics-modules/xxx/issues/new?title=%20ISSUE%20NAME%20HERE&body=**Describe%20the%20issue**%0A%0A**Steps%20to%20reproduce**%0A1.%20Step%20one%0A2.%20Step%20two%0A3.%20Step%20three%0A%0A**Expected%20behaviour**%0A%0A**Actual%20behaviour**%0A%0A**Build%20Environment**%0AArchitecture:%0AEpics%20Base%20Version:%0ADependent%20Module%20Versions:&labels=bug)
* [Request a feature](https://github.com/epics-modules/xxx/issues/new?title=%20FEATURE%20SHORT%20DESCRIPTION&body=**Feature%20Long%20Description**%0A%0A**Why%20should%20this%20be%20added?**%0A&labels=enhancement)

Regarding the license of tagged versions prior to synApps 4-5,
refer to the [LICENSE](LICENSE) file.

## Quick Start

1. Edit `configure/RELEASE` to set `SUPPORT` and `EPICS_BASE`
2. Edit `iocBoot/iocxxx/settings.iocsh` to set `IOC_NAME` and `PREFIX`
3. Build: `gnumake`
4. Start: `iocBoot/iocxxx/softioc/ioc.pl start`

## Building

Edit `configure/RELEASE` to point `SUPPORT` at your synApps installation.
The standard synApps module paths are pulled in automatically via
`-include $(SUPPORT)/configure/RELEASE`.

If you don't want to build all default target architectures, edit
`configure/CONFIG` to set `CROSS_COMPILER_TARGET_ARCHS`.

Run `gnumake` from the top-level directory.

## Configuring the IOC

### IOC Identity

Edit `iocBoot/iocxxx/settings.iocsh` to set:

* `IOC_NAME` -- used to derive the PV prefix, IOC name, and shell prompt
* `ENGINEER`, `LOCATION`, `GROUP` -- metadata for devIocStats and alive

### Hardware Support

Example configuration for common hardware is provided in
`iocBoot/iocxxx/examples/`. Copy the relevant files to the
`iocBoot/iocxxx/` directory, edit to match your hardware, and
add a line in the startup script to load them. Examples include:

* `examples/detectors/` -- areaDetector camera configurations
* `examples/serial_devices.iocsh` -- serial/network instrument support
* `examples/motors.iocsh` -- motor controller configurations
* `examples/optics.iocsh` -- slits, monochromators, tables, filters

### Autosave

Edit `auto_settings.req` and `auto_positions.req` to add any PVs
that aren't saved by the autobuild system. Ensure the autosave
directory is writable:

```
chmod a+w,g+s iocBoot/iocxxx/autosave
```

## Running the IOC

The `ioc.pl` script in `iocBoot/iocxxx/softioc/` manages the IOC:

```
softioc/ioc.pl start       # Start the IOC in a screen/procServ session
softioc/ioc.pl stop        # Stop the IOC
softioc/ioc.pl status      # Check if the IOC is running
softioc/ioc.pl restart     # Restart the IOC
softioc/ioc.pl console     # Connect to the IOC console
softioc/ioc.pl caqtdm      # Launch caQtDM display
softioc/ioc.pl medm        # Launch MEDM display
softioc/ioc.pl phoebus     # Launch Phoebus display
```

## Creating Additional IOCs

Multiple IOCs can share the same compiled binary. To create a
second IOC:

1. `cp -r iocBoot/iocxxx iocBoot/iocfoo`
2. Edit `iocBoot/iocfoo/settings.iocsh` -- change `IOC_NAME` to `foo`
3. Run `make` in `iocBoot/iocfoo/`

The `ioc.pl` script and all startup files automatically adapt to the
new IOC name. No file renames or other edits are required.

## Changing the PV Prefix

The PV prefix is derived from `IOC_NAME` in `settings.iocsh`. To
change it, edit that single line. For a more comprehensive rename
(including screen files and documentation), use the `changePrefix`
utility from `synApps/support/utils/`.
