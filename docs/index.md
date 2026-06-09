---
layout: default
title: XXX Overview
nav_order: 1
---


# XXX -- synApps IOC Template
{: .no_toc}

## Table of contents
{: .no_toc .text-delta }

- TOC
{:toc}

XXX is a template for creating EPICS IOCs that provide beam line support using the [synApps](https://github.com/BCDA-APS/synApps) module collection. While much of the module is build infrastructure to link support libraries and copy files to the right places, this page covers the parts that are important when creating your own IOC.


## Files Related to Building an IOC

### configure/RELEASE

An IOC's RELEASE file provides the build system and the IOC with the correct paths to any support modules referenced in other areas. Any macro definition in this file, or in any file included by this one, will be seen as a path to an EPICS module. This means the system will be able to find library files in the `<path>/lib` directory, header files in the `<path>/include` directory, and so on. Macros are defined as:

```
MACRO_NAME = /path/to/module
```

The Beamline Controls group provides a set of curated EPICS modules with a known set of interactions. This collection is called [synApps](https://github.com/BCDA-APS/synApps) and tagged releases can be found in `/APSshare/epics`. In the RELEASE file, the `SUPPORT` macro is set to one of those releases, then the synApps collection's RELEASE file is included. This provides the IOC with path definitions to all modules in that release of synApps as well as the version of EPICS base the support was built with.

A customized version of synApps can be built locally using [assemble_synApps](https://github.com/EPICS-synApps/assemble_synApps/tree/main). By switching the IOC's `SUPPORT` macro to point at the local build location, the IOC will pull in definitions to all of the local support modules instead.


### xxxApp/src/Makefile

While the RELEASE file provides the correct paths to find files, one must still add those files to construct the executable and the database definitions file for the IOC. This Makefile goes through the support modules that are in synApps and checks to see if a definition was made in the RELEASE file, and includes the correct files if it is.

Two name macros, `PROD_NAME` and `DBD_NAME`, are used to construct two lists through the file: `$(PROD_NAME)_LIBS` and `$(DBD_NAME)_DBD`. `$(PROD_NAME)_LIBS` contains all the library files containing support code and functions that the IOC can call and is used to construct an executable named `$(PROD_NAME)`. Meanwhile, `$(DBD_NAME)_DBD` constructs a database definitions file named `$(DBD_NAME).dbd` for the IOC.

A database definitions file serves two purposes. First, it defines the structure of EPICS record types, telling the IOC what the various field names are and the type and size of data stored in that field. Secondly, it provides the IOC with the links between the compiled support code and the text names used to refer to said support in database files. An IOC starts as a mostly clean slate -- it doesn't know anything about EPICS record types, and only understands a few commands on the shell. To access all the code compiled into the executable, the IOC needs to load the database definitions file and then run a registration function that configures the IOC to understand all the record types, drivers, functions, and variables in the dbd file.

When adding a new module outside the ones normally handled by synApps, once you have the path to the module set up in the RELEASE file, you would add their library and dbd files into the list:

```makefile
$(DBD_NAME)_DBD += newModuleSupport.dbd
$(PROD_NAME)_LIBS := newModule $($(PROD_NAME)_LIBS)
```

The library list is set up differently because libraries must be included in a certain order. All of a library's dependencies must be added before the library itself. So make sure when adding new modules, you add it into the list after any of the other modules that it might be dependent on.

### iocBoot/iocxxx/Makefile

The last file necessary to properly build an IOC is the Makefile in the boot directory. This file tells the build system to take the IOC's RELEASE file and use it to construct a file with all the path definitions in a mode that the IOC shell environment is capable of using. There are two variables set in this file. `ARCH` is the architecture that the IOC will run on, and `TARGETS` defines what file types to generate. The three file types are `cdCommands`, `envPaths`, and `dllPath.bat` -- which you use depends on the operating system. The `cdCommands` file has path definitions that the vxWorks shell can run, while `envPaths` can be run under the ioc or lua shell. `dllPath.bat` is added into TARGETS for Windows to provide the OS with the right paths to load support DLLs.


### xxxApp/Db

Not fully necessary for a build, but this directory contains custom databases or autosave req files for the IOC. All files with the following extensions will be copied into a top-level `/db` folder when the IOC is built: `.template`, `.db`, `.vdb`, `.req`. If you make a change to a file in this directory, remember to run build to have it properly installed to the top-level.


## Files Related to Running an IOC

For a guide to configuring hardware, display managers, autosave, and saveData in a running IOC, see [Configuring an IOC](configuring.html).

### iocBoot/iocxxx/st.cmd.\<ARCH\>

This is the basic template for loading all support for an IOC on a given architecture. You provide this file to the IOC's executable when you want to run -- it goes through, line by line, and runs the commands listed in the operating shell in order to configure the IOC. Most of this file shouldn't need to be changed. It is set to include the correct path-defining file created by the iocBoot Makefile, load the database definitions file constructed by the xxxApp/src Makefile, run the registration function, and then load some common IOC support.

After the line `< common.iocsh` you can then include any custom support for the IOC, either by directly running functions to load support, or by telling the shell environment to include other files with commands.

### iocBoot/iocxxx/common.iocsh

This contains a common set of support that most IOCs may want to make use of. Primarily, it sets up autosave and the alive heartbeat record, but it also gives access to a set of calcs, transform records, lua script records, and string sequences to help connect pieces of support together. You shouldn't need to adjust this file.

### iocBoot/iocxxx/settings.iocsh

This defines environment variables that are commonly used throughout different support.

### iocBoot/iocxxx/examples

This directory has example code for support that one might be loading into an IOC. It makes it easy to copy files out to the main directory, make edits to match up with your specific needs, and then add a line in the st.cmd file to tell it to load said support.

### iocBoot/iocxxx/softioc

This is the directory that hosts the controls for Linux soft IOCs. `ioc.pl` takes in a set of commands defined in the commands folder, allowing one to start/stop/restart an IOC in the background, connect to see the console of a running IOC, launch the default GUI, or check if an IOC is running. New commands can be added to the commands folder and the script will automatically pick them up, if one is so inclined.

The `ioc.pl` script can be symbolically linked anywhere and should be able to properly determine the paths to launch the IOC. If a problem does occur, you can manually define any paths that are used, as well as which startup script is used, and you can even change the basic shell commands that the script uses if needed.


## Creating Additional IOCs

Multiple IOCs can share the same compiled binary. To create a second IOC from the template:

1. `cp -r iocBoot/iocxxx iocBoot/iocfoo`
2. Edit `iocBoot/iocfoo/settings.iocsh` -- change `IOC_NAME` to `foo`
3. Run `make` in `iocBoot/iocfoo/`

The `ioc.pl` script and all startup files automatically adapt to the new IOC name based on the directory name. No file renames or other edits are required.
