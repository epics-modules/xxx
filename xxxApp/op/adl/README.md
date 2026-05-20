
The `ioc_*.adl` screens expect to receive two macros:

* `P` : the IOC prefix, including the trailing ":"
* `ioc` : the IOC prefix without the trailing ":"
  as needed for the screens supplied by iocStats.

The main screen is `xxx.adl`, which provides a tabbed interface
to all the individual `ioc_*.adl` screens (motors, optics,
detectors, direct I/O, devices, tools).

Equivalent screens are also available in caQtDM (`.ui`) and
Phoebus (`.bob`) formats under `xxxApp/op/ui/` and
`xxxApp/op/bob/autoconvert/`. The caQtDM and Phoebus screens
can be regenerated from the gestalt YAML files in `xxxApp/op/yml/`.

Start MEDM from the IOC's softioc directory:

```
softioc/ioc.pl medm
```

Or launch MEDM directly:

```
medm -macro "P=xxx:,ioc=xxx" -x xxx.adl &
```
