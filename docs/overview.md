---
layout: default
title: XXX Overview
nav_order: 2
---


# The IOC 

An IOC, or Input/Output Controller, is a platform capable of hosting EPICS PVs for runtime control. EPICS support libraries containing the code to load databases containing PVs and to connect those PVs up to communicate with devices are linked together into an executable. Said program runs one of the compatible shell environments (vxWorks shell, iocsh, lua shell) and uses a startup script to configure itself and load the support desired.

The template of most IOCs that are deployed by the Beamline Controls group is the XXX IOC module, which can be found at https://github.com/epics-modules/xxx. While much of this is just code infrastructure to get everything to build and to copy files to the right places, we'll go over the parts that are important for when creating your own IOC.

## Files Related to Building an IOC

### configure/RELEASE

An IOC's RELEASE file is what provides the build system and the IOC with the correct paths to any support modules referenced in other areas. Any macro definition in this file, or in any file included by this one, will be seen as a path to an EPICS module. This means the system will be able to find library files that are located in the \<path\>/lib directory, header files that are located in the \<path\>/include directory, and so on. Macros are defined in the file in the following way:

```
MACRO_NAME = /path/to/module
```

The Beamline Controls group provides a set of curated EPICS modules that have a known set of interactions with each other and cover much of the support needed by standard IOCs. This collection is called synApps and tagged releases can be found in /APSshare/epics. In the RELEASE file, you will see the SUPPORT macro being set to one of those releases then we include the synApps collection's version of the RELEASE file. Which then provides your IOC with the path definitions to all of the modules that are included in that release of synApps as well as to the version of EPICS base that the support was built with.

A customized version of synApps can be built locally using the assemble_synApps script located at [assemble_synApps](https://github.com/EPICS-synApps/assemble_synApps/tree/main). By switching the IOC's SUPPORT macro to point at the local location that you build synApps in, the IOC will then pull in the definitions to all of your local support modules instead.


### xxxApp/src/Makefile 

While the RELEASE file provides the correct paths to find files, one must still add those files in order to construct the executable and the database definitions file for the IOC. This Makefile goes through the support modules that are in synApps and checks to see if a definition was made in the RELEASE file, and includes the correct files if it is.

We define two name macros, PROD_NAME and DBD_NAME, which are then used to construct two lists through the file, ```$(PROD_NAME)_LIBS``` and ```$(DBD_NAME)_DBD```. ```$(PROD_NAME)_LIBS``` contains all the library files containing support code and functions that the IOC can call and is used to construct an executable named ```$(PROD_NAME)```. Meanwhile, ```$(DBD_NAME)_DBD``` will construct a database definitions file named ```$(DBD_NAME).dbd``` for the IOC.

A database definitions file serves two purposes. First, it defines the structure of EPICS record types, telling the IOC what the various field names are and the type and size of data stored in that field. Secondly, it provides the IOC with the links between the compiled support code and the text names that will be used to refer to said support in database files. An IOC starts as a mostly clean slate, it doesn't know anything about EPICS record types, and only understands a few commands on the shell. To access all the code that is compiled into the executable, the IOC needs to load the database definitions file and then run a registration function that will go through and configure the IOC to understand all the record types, drivers, functions, and variables in the dbd file.

When adding a new module outside the ones normally handled by synApps, once you have the path to the module set up in the RELEASE file, you would add their library and dbd files into the list. Such an addition would like like the following:


```
$(DBD_NAME)_DBD += newModuleSupport.dbd
$(PROD_NAME)_LIBS := newModule $($(PROD_NAME)_LIBS)
```

The library list is set up differently because libraries must be included in a certain order. All of a library's dependencies must be added before the library itself is. So make sure when adding new modules, you add it into the list after any of the other modules that it might be dependent on.

### iocBoot/iocxxx/Makefile

The last file necessary to go over in order to properly build an IOC is the Makefile in the boot directory. This file tells the build system to take the IOC's RELEASE file and use it to construct a file with all the path definitions in a mode that the IOC shell environment is capable of using. There are two variables that are set in this file. The ARCH is the architecture that the IOC will be run on, and the TARGETS variable defines what file type to generate. The three file types are cdCommands, envPaths, and dllPath.bat, which of these you will use is dependent on what operating system you are going to be using. The cdCommands file has path definitions in a mode that the vxWorks shell can run, while envPaths can be run under the ioc or lua shell. dllPath.bat is then added into TARGETS if you are going to be running on a Windows computer as it provides the Windows OS with the right paths to load support dll's.


### xxxApp/Db 

Not fully necessary to a build, but this directory contains custom databases or autosave req files for the IOC. All files that have the following file types will be copied into a top-level /db folder when the IOC is built: .template, .db, .vdb, .req. If you make a change on a file in this directory, remember to run build to have it properly installed to the top-level.


## Files Related to Running an IOC

### iocBoot/iocxxx/st.cmd.\<ARCH\> 

This is the basic template of loading all support for an IOC for a given arch. You will provide this file to the IOC's executable when you want to run, it will go through, line by line, and run the commands listed in the operating shell in order to configure the IOC for running. Most of this file shouldn't need to be changed, it is set to include the correct path-defining file created by the iocBoot Makefile, load the database definition file constructed by the xxxApp/src Makefile, run the registration function, and then load some common IOC support.

After the line "< common.iocsh" you can then include any custom support for the IOC, either by directly running functions to load support, or by telling the shell environment to include other files with commands.

### iocBoot/iocxxx/common.iocsh 

This contains a common set of support that most IOCs may want to make use of. Primarily, it sets up autosave and the alive heartbeat record, but it also gives access to a set of calcs, transform records, lua script records, and string sequences to help connect pieces of support together. You shouldn't need to adjust this file.

### iocBoot/iocxxx/settings.iocsh 

This defines environment variables that are commonly used throughout different support.

### iocBoot/iocxxx/examples 

This directory has example code for support that one might be loading into an IOC. It makes it easy to copy files out to the main directory, make edits to match up with your specific needs, and then add a line in the st.cmd file to tell it to load said support.

### iocBoot/iocxxx/softioc

This is the directory that hosts the controls for Linux soft IOCs. xxx.pl takes in a set of commands defined in the commands folder, allowing one to start/stop/restart an IOC in the background, connect to see the console of a running IOC, launch the default GUI, or to check if an IOC is running. New commands can be added to the commands folder and the script will automatically pick them up, if one is so inclined.

The xxx.pl script can be symbolically linked anywhere and should be able to properly determine the paths to properly launch the IOC. If a problem does occur, you can manually define any paths that are used, as well as which startup script is used, and you can even change the basic shell commands that the script uses if needed.
