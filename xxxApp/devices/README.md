# Device catalog

A single source of truth for this application's devices, consumed by **two**
independent tools:

- **IOC boot** (stock YAML parser) reads device instances and their config.
- **Screen generation** ([gestalt](https://github.com/BCDA-APS/gestalt)) reads the
  same data to build related-display buttons.

Both read one assembled YAML file; there is no second, hand-maintained copy to
drift out of sync.

## Two tiers

The catalog is split by *ownership*, because one shared build commonly serves
many IOCs (e.g. several gigE cameras that share an executable and screens,
differing only by launch macros).

| Tier | Lives in | Known at | Content |
|------|----------|----------|---------|
| **Shared type library** | `xxxApp/devices/` | build time | Device *classes* (scaler, …) whose support is built into the executable. IOC-agnostic screen templates. |
| **Per-IOC instances** | `iocBoot/ioc<name>/devices/` | deploy time | The actual devices this IOC has, their macros, init order. |

The type library describes what *can* be loaded and displayed by this
executable, so it is common to every IOC built from it. It is assembled once and
installed to the top-level `devices/` directory. Each IOC then assembles its own
device file from that shared library plus its own instance snippets.

```
xxxApp/devices/
    Makefile                 # assembles + installs the shared type library
    10_scaler.yml            # scaler device class (anchor: _Scaler)
    20_areadetector.yml      # areaDetector classes (_AD_SimDetector, _AD_Andor, ...)
    30_dxp.yml               # XIA DXP single-element classes (_DXP_Saturn, _DXP_Micro)
    30_mca.yml               # MCA class (_MCA)
    30_quadem.yml            # quad electrometer class (_QuadEM)
    30_xspress3.yml          # Xspress3 fluorescence detector class (_Xspress3)
    40_analogio.yml          # analog I/O classes (_DAC128V, _IP330, _VME_DAC8)
    40_asyn.yml              # asyn serial/GPIB class (_asyn_Octet)
    40_digitalio.yml         # digital/binary I/O classes (_IpUnidig, _Busy)
    40_measComp.yml          # Measurement Computing DAQ models (_MC_USB1808, _MC_TC32, ...)
    40_softglue.yml          # softGlue FPGA fabric class (_SoftGlue)
    40_yokogawa.yml          # Yokogawa DAQ classes (_Yokogawa_GM10, _Yokogawa_MW100)
    50_delaygen.yml          # delay/pulse generator classes (_SRS_DG645, _BNC_505, ...)
    50_optics.yml            # optics classes (_Filter_Drive, _Slit_Soft, _EPID_Feedback)
    50_pid.yml               # PID feedback loop class (_PID)
    50_piezo.yml             # Nano2k piezo controller class (_Nano2k)
    50_preamp.yml            # preamp classes (_SRS_SR570, _Femto, _Femto_DLPCA_200, ...)
    50_shutter.yml           # XIA fast shutter class (_XIA_Shutter)
    50_tempcontroller.yml    # temp controller classes (_LakeShore, _Eurotherm_2000, _Love_Controller)
    50_utility.yml           # software utility classes (_Timer, _PvHistory, _Throttle, ...)
    50_vacuum.yml            # vacuum classes (_IonPump, _VacSen)
    60_ioc_status.yml        # IOC status bundle (_IOC_Status)
    60_motor.yml             # motor record class, individual + bank (_Motor); Symetrie hexapod (_Symetrie_Hexapod)
    60_scans.yml             # scan records bundle (_Scans)
    60_user_calcs.yml        # user calc class (_UserCalc) + bundle (_User_Calcs)
    60_user_scripts.yml      # lua user scripts bundle (_User_Scripts)
devices/                     # BUILD ARTIFACTS (gitignored)
    00_device_templates.yml  # assembled shared type library (one per executable)
    iocxxx_devices.yml       # IOC xxx's assembled device file (IOC name avoids collisions)
    ioccam1_devices.yml      # ...another IOC's device file, same shared dir
iocBoot/iocxxx/
    devices/
        Makefile             # assembles + installs this IOC's device file
        10_globals.yml       # per-IOC global scalars
        70_scalers.yml       # per-IOC scaler instances
```

Both tiers install into the top-level `devices/` directory. The shared type
library is `00_device_templates.yml`; each IOC's assembled file carries the IOC name
(`<name>_devices.yml`) so that IOCs sharing one executable do not collide in
that shared directory.

### Two flavors of type

Most types are **per-device**: an instance supplies an `instance` value (mapped
to the device's identifying macro), an optional `name` label, and a `links` list
selecting from the type's screens. Each type file's comment block documents its
instance field and available screen keys.

A few types (rank `60`) are **bundles**: they have no per-device instance macro,
only the IOC `prefix`. They group a fixed set of related software/IOC screens
(IOC status, scans, user scripts) into a named list that an instance
references directly (e.g. `links: "{MyScans[links]}"`). Bundles recur
identically on every IOC, so there is nothing per-device to parameterize.

Some per-device types (`_Motor`, `_UserCalc`) expose the **same class at two
granularities**: an individual record screen (keyed `screen`) and one or more
N-record *bank* screens (keyed `bank_8`, `bank_10`, …). The instance's `links`
list picks whichever projection it wants, or mixes them. Where a bank screen
takes a positional list of record names (e.g. a motor bank's `M1..M8`), the
instance supplies that full macro string in a `bank_macros` field and the type
just names the file; banks that take only the prefix (e.g. `userCalcs10`) need
no extra field.

## IOC startup: the `st.cmd` member

A device type may carry an **`st.cmd`** member: a block of
[lua-shell](https://github.com/epics-modules/lua) (`luash`) code that issues the
IOC startup commands needed to instantiate the device. A (future) lua parser
reads the same assembled catalog the screens come from and, for each instance,
runs that instance's type `st.cmd` snippet.

The contract the snippet is written against:

- **Instance macros are injected as luash globals.** The instance's catalog
  fields (`instance`, and any other macros the type defines, e.g. `channel`,
  `mca`) are set as global variables in the luash state before the snippet runs,
  using the same `name=value` convention as `iocshLoad`/`dbLoadRecords`. String
  values arrive quoted, so a snippet references them as bare lua identifiers
  (`instance`, `channel`, …).
- **The IOC-shell environment is available.** Luash falls back to the running
  EPICS environment for any identifier it does not otherwise resolve, so a
  snippet references environment variables directly as bare identifiers:
  `PREFIX` (from `settings.iocsh`, the single source of truth shared with the
  screens' `{prefix}`) and every module install path (`SCALER`, `ASYN`,
  `ADCORE`, … from `envPaths`). Registered iocsh functions (`iocshLoad`,
  `dbLoadRecords`, `drvScalerSoftConfigure`, …) are callable directly.
- **Prefer delegating to the module's own iocsh fragment.** Where a support
  module (or the in-repo `iocBoot/ioc<name>/examples/`) ships a parameterized
  `.iocsh` startup fragment, the snippet should `iocshLoad` it rather than
  re-implement its commands, so the module keeps ownership of its own startup.
  Pass the IOC prefix explicitly for robustness; let module paths resolve from
  the environment. Inline `dbLoadRecords`/driver-config directly only for
  modules that ship no fragment.
- **Post-`iocInit` commands** go inside `doAfterIocInit(...)` in the snippet
  (this is the registered EPICS iocsh function name; luash resolves the bare
  identifier to it).
- **It is a boot-only field.** The snippet is a plain YAML block scalar with no
  gestalt `{...}` templating, so gestalt ignores it (it is not a screen or links
  field) and a stock YAML parser reads it as an inert string. The dual-consumer
  invariant is preserved.

Example (`_Scaler`): delegate to the scaler module's `softScaler.iocsh`, passing
the resolved prefix and this instance's name:

```yaml
st.cmd: |
    iocshLoad(SCALER .. "/iocsh/softScaler.iocsh",
              "PREFIX=" .. PREFIX .. ", INSTANCE=" .. instance)
```

### Hardware-connection boot parameters

Many device types need hardware-connection details at boot that the screens do
not use (asyn port names, IP addresses, IPAC carrier/slot, GPIB addresses, model
database basenames, etc.). Each type's header comment lists its `st.cmd boot
parameters`, split into required and optional-with-default:

- **Required** parameters have no catalog default; the instance must supply them
  (e.g. `port`, `ip_addr`, `int_vec`, `unique_id`, `id`).
- **Optional** parameters carry a static default field on the type (e.g.
  `carrier: "0"`, `slot: "0"`, `trigger: "Input"`, `nchan: "2048"`); an instance
  overrides them only when needed.

A recurring distinction: a snippet that *creates* an asyn port supplies/derives
its name, while a snippet that only *attaches* to an already-configured port
(serial preamps, temperature controllers, raw asyn records, serial delay
generators, serial motor controllers) takes that port's name as a `port` /
`serial` boot parameter — the port itself is created by whichever device owns it.

### Shared `st.cmd` via base mixins

Where several models share one startup shape, a `_*_base` anchor carries the
shared `st.cmd` (and shared defaults) and each concrete type pulls it in with a
YAML merge key (`<<: *_Base`), overriding only the distinguishing field (usually
a `model` / `fragment` basename). These bases are **inert**: they define no
`screen`/`links`, are never referenced as an instance `type`, and exist only to
be merged. They do raise the count of top-level `_`-prefixed anchors:

- `_MC_base` (measComp), `_DXP_base` (dxp) — carry only `st.cmd` + defaults.
- `_AD_Base` / `_AD_Base_NoId` (areaDetector), `_Motor_Util` (motor) — also carry
  the shared screen set that the concrete types reuse.

### Screen-only types (no `st.cmd`, by design)

A type is intentionally left screen-only when its startup is inherently
site-specific wiring rather than a uniform catalog parameter set. These are the
documented exceptions (each type's header explains its specific reason):

| Type(s) | Reason |
|---|---|
| `_VME_DAC8` | std ships only a MEDM screen, no database/driver-config |
| `_Femto`, `_Femto_DLPCA_200`, `_Femto_DHPCA_100`, `_Femto_DDPCA_300` | gain-select bits wired to specific digital-output channels |
| `_PID` | requires per-application `INP`/`OUT` links + gain/limit fields |
| `_EPID_Feedback` | requires per-application feedback `IN`/`OUT` links + calc number |
| `_Slit_Soft` | virtual slit built from two site-specific motor PVs (`mXp`/`mXn`) |
| `_CountDownTimer`, `_AlarmClock` | software compositions of generic calc records via a site substitutions file |
| `_Motor` | vendor-neutral record UI only; per-axis records are site config (use `_Motor_*`) |
| `_Symetrie_Hexapod` | PowerPMAC SSH connection (credentials) + per-axis substitutions |
| `_UserCalc` | a view onto records created once by the `_User_Calcs` bundle load |

For the bundle types (`_IOC_Status`, `_Scans`, `_User_Calcs`, `_User_Scripts`),
`st.cmd` loads only the clean, self-contained records the bundle's screens view;
each flags (in its header comment) which `common.iocsh` line(s) it supersedes for
the future parser, and which core-infrastructure pieces (autosave core setup,
alive `RHOST`, scan1 configMenu) deliberately remain `common.iocsh`-owned.
`common.iocsh` itself is not edited.

## How assembly works

The build uses the native EPICS `ASSEMBLIES` facility
(`assembleSnippets.pl`), which concatenates snippets in rank order.

1. **Shared library** (`xxxApp/devices/Makefile`): the type snippets (`*.yml`)
   → `devices/00_device_templates.yml`, installed via the custom `DEVICES` file type
   (declared in `configure/CONFIG_SITE`).
2. **Per-IOC file** (`iocBoot/ioc<name>/devices/Makefile`): the installed
   `00_device_templates.yml` **plus** this IOC's snippets (`*.yml`) →
   `devices/<name>_devices.yml`. The output name is derived from the parent
   directory, so this Makefile has no IOC name to maintain — it can be copied
   into any `iocBoot/ioc<name>/devices/` unchanged.

Both Makefiles use the same `DEVICES +=` install idiom. The shared tier uses
`COMMON_ASSEMBLIES` (output is arch-independent, built once in `O.Common`, and
bridged to the install rule with `vpath`); the per-IOC tier uses `ASSEMBLIES`
(output built in `O.$(T_A)`, which the install rule finds directly, so no
`vpath` is needed). The per-IOC assembly lives in a `devices/` *subdirectory*
of the boot dir, not in the boot Makefile itself: `iocBoot/ioc<name>` uses
`RULES.ioc`, which does not run the build passes the `ASSEMBLIES`/`DEVICES`
machinery needs, but a regular subdirectory under it (included via
`DIRS += devices`) uses the normal `RULES` where that machinery works. The
subdir name must be dotless — the directory recursion separator is `.`, so
`devices.d` would be misparsed.

Because `xxxApp` installs before `iocBoot` builds (see the top-level Makefile's
`iocBoot_DEPEND_DIRS`), the shared library is present when the per-IOC assembly
runs.

## Rules and conventions

- **Anchor naming.** A type anchor is named to minimize collisions and read as
  a device identity:
  - Use `_Vendor_Model` when the device has a clear vendor/model
    (`_SRS_SR570`, `_SRS_DG645`, `_XIA_Shutter`, `_Yokogawa_GM10`,
    `_Love_Controller`, `_Eurotherm_2000`). The Measurement Computing DAQ family
    uses the `_MC_` namespace per model (`_MC_USB1808`, `_MC_TC32`, …) so the
    whole family groups together.
  - Use a bare `_Class` name for true generics where the EPICS class *is* the
    identity, with no meaningful single vendor (`_Scaler`, `_MCA`, `_QuadEM`,
    `_Motor`, `_Busy`, `_IonPump`, `_DAC128V`, `_IP330`, `_IpUnidig`,
    `_UserCalc`, and the bundles `_IOC_Status`, `_Scans`, `_User_Calcs`,
    `_User_Scripts`).
  - Use the `_AD_` namespace for the areaDetector family (`_AD_Base`,
    `_AD_Andor`, `_AD_Eiger`, `_AD_SimDetector`, …) so the whole family groups
    together regardless of hardware vendor.
  - **Capitalization:** PascalCase segments joined by `_`, with acronyms kept
    uppercase (`SRS`, `XIA`, `AD`, `MCA`, `IP330`). The one exception is `asyn`,
    which stays lowercase by EPICS convention (`_asyn_Octet`).
- **Screen-key naming.** Keep screen keys lowercase snake_case, and keep the
  "main screen" key uniform:
  - A type's single primary screen is always keyed `screen`; secondary screens
    get descriptive suffixes (`screen_16`, `screen_detail`, `screen_tiny`,
    `more`, …).
  - A bundle's single screen list is always keyed `links`, so instances read
    uniformly: `links: "{MyBundle[links]}"`.
- **Snippet filenames must start with a digit.** `assembleSnippets.pl`
  silently ignores any file whose basename does not begin with a number
  (and ignores `~` backups). This is why the shared library installs as
  `00_device_templates.yml` — it is consumed as a snippet by the per-IOC assembly.
- **Rank convention** (the numeric filename prefix orders the final file).
  There are two rank spaces:
  - *Shared type library* (`xxxApp/devices/`): the prefix groups related
    device classes but carries no hard ordering requirement between files —
    each type file is self-contained (any `<<:` merge of one anchor into
    another, e.g. the areaDetector base, lives within a single file). Rough
    grouping used here: `10` scalers, `20` areaDetector, `30` detectors/EM,
    `40` I/O ports, `50` other devices, `60` software/IOC bundles.
  - *Per-IOC instances* (`iocBoot/ioc<name>/devices/`): the shared type library
    assembles as rank `00` (`00_device_templates.yml`), so it is pulled in first;
    then `10` globals, then instances ordered by initialization dependency (e.g.
    serial ports before serial devices, as finer ranks are introduced).
  In the final per-IOC assembly the whole shared library (installed as the
  single `00_device_templates.yml`) precedes the per-IOC globals and instance
  files, so every type anchor is defined before the instances that merge it.
  Globals carry no YAML anchors today, so their position after the templates is
  safe; a stock parser resolves the completed mapping regardless of order. If a
  global is ever referenced by a template via a YAML alias (`*anchor`), it would
  have to be defined textually before that use.
- **Snippets use only standard YAML** (`&anchor`, `<<: *anchor`, merge keys).
  No gestalt-only directives (`#include`) in these snippets — those belong in
  the gestalt layout files under `xxxApp/op/yml/`. This keeps the assembled
  file consumable by a stock YAML parser.
- **`{...}` templating is screen-only.** Fields like `screen`, `links`, labels
  and macros use gestalt `{...}` macros. A stock parser reads them as literal
  strings and ignores them; boot reads only the plain scalar fields.
- **`prefix` is a boot-time passthrough**, not baked at assembly, so one shared
  build/type library serves many IOCs. Boot uses `$(PREFIX)` from
  `settings.iocsh`; gestalt supplies `{prefix}` per IOC at screen generation.

## Build artifacts (gitignored)

- Top-level `devices/` (the installed shared library)
- `iocBoot/ioc<name>/<name>_devices.yml` (the per-IOC assembled device file)

Only the source snippets and Makefiles (`xxxApp/devices/`,
`iocBoot/ioc<name>/devices/`) are tracked.
