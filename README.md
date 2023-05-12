# xxx
APS BCDA synApps module: xxx

XXX is a template to use when creating an EPICS IOC that provides beam line support.
It uses the various modules that comprise synApps and other support.

For more information, see
   http://www.aps.anl.gov/bcda/synApps

converted from APS SVN repository: Fri Nov 20 18:04:37 CST 2015

Regarding the license of tagged versions prior to synApps 4-5,
refer to http://www.aps.anl.gov/bcda/synApps/license.php

[Report an issue with XXX](https://github.com/epics-modules/xxx/issues/new?title=%20ISSUE%20NAME%20HERE&body=**Describe%20the%20issue**%0A%0A**Steps%20to%20reproduce**%0A1.%20Step%20one%0A2.%20Step%20two%0A3.%20Step%20three%0A%0A**Expected%20behaivour**%0A%0A**Actual%20behaviour**%0A%0A**Build%20Environment**%0AArchitecture:%0AEpics%20Base%20Version:%0ADependent%20Module%20Versions:&labels=bug)  
[Request a feature](https://github.com/epics-modules/xxx/issues/new?title=%20FEATURE%20SHORT%20DESCRIPTION&body=**Feature%20Long%20Description**%0A%0A**Why%20should%20this%20be%20added?**%0A&labels=enhancement)

* [HTML documentation](https://epics-modules.github.io/xxx)


### Usage

Edit configure/RELEASE to set the variable SUPPORT

If you don't want to build all of the default target architectures
(see the variable CROSS_COMPILER_TARGET_ARCHS in 
synApps/support/configure/CONFIG, or in base/configure/CONFIG_SITE),
then edit configure/CONFIG to set the variable CROSS_COMPILER_TARGET_ARCHS.

Edit iocBoot/iocxxx/Makefile to set the variable ARCH and correct targets

Edit iocBoot/iocxxx/st.cmd.* to agree with your hardware.
Example code is provided in the iocBoot/iocxxx/examples folder.

Edit iocBoot/iocxxx/auto*.req to add any PV's that aren't saved by the
autobuild system.

chmod a+w,g+s iocBoot/iocxxx/autosave

Run synApps/support/utils/changePrefix to change the prefix from 'xxx'
to whatever you want

Run gnumake
