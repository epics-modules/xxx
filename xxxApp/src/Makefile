TOP=../..

include $(TOP)/configure/CONFIG
#----------------------------------------
#  ADD MACRO DEFINITIONS AFTER THIS LINE
#=============================

# For Kate Feng's implementation of devScaler.c, which uses Till
# Straumann's basicIoOps.h to bridge any mismatch between endianness
# of Joerger scaler hardware and endianness of processor.
#USR_CFLAGS += -DHAS_IOOPS_H

#=============================
# build an ioc application

# PROD_NAME is used by ADCORE to add libraries
# DBD_PREFIX is used by ADCORE to add dbd files
PROD_NAME = xxx
DBD_PREFIX = iocxxx
PROD_IOC = $(PROD_NAME)

# Note that the order in which .dbd files and libraries are added to a list
# variable is important.  For .dbd files, things must be defined before they
# are referenced by a later .dbd file.  For libraries, things must be referenced
# before they are searched for; otherwise they won't be included.

# Custom stuff in development

##################################################################
# First, define $(DBD_NAME)_DBD and $(PROD_NAME)_LIBS from the modules
# defined in RELEASE
##################################################################
DBD_SUFFIX_cygwin32 = $(error Cygwin not supported)
DBD_SUFFIX_Darwin = Darwin
DBD_SUFFIX_Linux = Linux
DBD_SUFFIX_RTEMS = $(error RTEMS not supported)
DBD_SUFFIX_vxWorks = VX
DBD_SUFFIX_WIN32 = Win$(if $(findstring 32, $(T_A)),32,64)
DBD_NAME = $(DBD_PREFIX)$(DBD_SUFFIX_$(OS_CLASS))

DBD  += $(DBD_NAME).dbd

ifndef ADCORE
  $(DBD_NAME)_DBD += base.dbd
endif

ifdef ADCORE
  # areaDetector provides a Makefile for things it needs and supplies
  -include $(ADCORE)/ADApp/commonDriverMakefile
endif

#ifdef TDS3000
#  $(DBD_NAME)_DBD += devTDS3000.dbd
#  $(PROD_NAME)_LIBS := devTDS3000 $($(PROD_NAME)_LIBS)
#endif

#ifdef CAPUTLOG
#  $(DBD_NAME)_DBD += caPutLog.dbd
#  $(PROD_NAME)_LIBS := caPutLog $($(PROD_NAME)_LIBS)
#endif

ifdef CAPUTRECORDER
  $(DBD_NAME)_DBD += caputRecorder.dbd
  $(PROD_NAME)_LIBS := caputRecorder $($(PROD_NAME)_LIBS)
endif

ifdef SNCSEQ
  ifeq (seq-2-1, $(findstring seq-2-1, $(SNCSEQ)))
    $(DBD_NAME)_DBD += devSequencer.dbd
    $(PROD_NAME)_LIBS := seqDev seq pv $($(PROD_NAME)_LIBS)
  else ifeq (seq-2.1, $(findstring seq-2.1, $(SNCSEQ)))
    $(DBD_NAME)_DBD += devSequencer.dbd
    $(PROD_NAME)_LIBS := seqDev seq pv $($(PROD_NAME)_LIBS)
  else
    # seq 2.2.
    $(PROD_NAME)_LIBS := seq pv $($(PROD_NAME)_LIBS)
  endif
endif

ifdef ASYN
  ifndef ADCORE
    $(DBD_NAME)_DBD += asyn.dbd
  endif
  $(DBD_NAME)_DBD += drvAsynSerialPort.dbd drvAsynIPPort.dbd drvVxi11.dbd devGpib.dbd
  $(PROD_NAME)_LIBS := asyn $($(PROD_NAME)_LIBS)
endif

ifdef STD
  $(DBD_NAME)_DBD += stdSupport.dbd
  $(PROD_NAME)_LIBS := std $($(PROD_NAME)_LIBS)
endif

ifdef CALC
  ifndef ADCORE
    $(DBD_NAME)_DBD += calcSupport.dbd
  endif
  $(PROD_NAME)_LIBS := calc $($(PROD_NAME)_LIBS)
endif

ifdef BUSY
  ifndef ADCORE
    $(DBD_NAME)_DBD += busySupport.dbd
  endif
  $(PROD_NAME)_LIBS := busy $($(PROD_NAME)_LIBS)
endif

ifdef SSCAN
  ifndef ADCORE
    $(DBD_NAME)_DBD += sscanSupport.dbd
  endif
  $(PROD_NAME)_LIBS := sscan $($(PROD_NAME)_LIBS)
  ifdef SNCSEQ
    $(DBD_NAME)_DBD += sscanProgressSupport.dbd
    $(PROD_NAME)_LIBS := scanProgress $($(PROD_NAME)_LIBS)
  endif
endif

ifdef AUTOSAVE
  ifndef ADCORE
    $(DBD_NAME)_DBD += asSupport.dbd
  endif
  $(PROD_NAME)_LIBS := autosave $($(PROD_NAME)_LIBS)
endif

ifdef OPTICS
  $(DBD_NAME)_DBD += opticsSupport.dbd
  $(PROD_NAME)_LIBS := optics $($(PROD_NAME)_LIBS)
endif

ifdef MCA
  $(DBD_NAME)_DBD += mcaSupport.dbd
  $(PROD_NAME)_LIBS := mca $($(PROD_NAME)_LIBS)
endif

ifdef QUADEM
  $(DBD_NAME)_DBD += drvAHxxx.dbd drvTetrAMM.dbd
  $(PROD_NAME)_LIBS := quadEM $($(PROD_NAME)_LIBS)
endif

ifdef IP
  $(DBD_NAME)_DBD += ipSupport.dbd
  $(PROD_NAME)_LIBS := ip $($(PROD_NAME)_LIBS)
endif

ifdef LUA
  $(DBD_NAME)_DBD += luaSupport.dbd
  $(PROD_NAME)_LIBS := lua $($(PROD_NAME)_LIBS)
endif

ifdef MODBUS
  $(DBD_NAME)_DBD += modbusSupport.dbd
  $(PROD_NAME)_LIBS := modbus $($(PROD_NAME)_LIBS)
endif

ifdef MOTOR
  $(DBD_NAME)_DBD += motorSupport.dbd devAcsMotor.dbd devAerotech.dbd
  $(DBD_NAME)_DBD += devAttocube.dbd devFaulhaberMotor.dbd devImsMotor.dbd
  $(DBD_NAME)_DBD += devKohzuMotor.dbd devMclennanMotor.dbd devMicos.dbd
  $(DBD_NAME)_DBD += devMicroMo.dbd devNewFocus.dbd devNewport.dbd
  ifdef SNCSEQ
  $(DBD_NAME)_DBD += devAerotechSeq.dbd devNewportSeq.dbd
  endif
  $(DBD_NAME)_DBD += devOriel.dbd devPC6K.dbd devPIJena.dbd devPIMotor.dbd
  $(DBD_NAME)_DBD += devSPiiPlus.dbd devSmartMotorMotor.dbd devSoftMotor.dbd
  $(DBD_NAME)_DBD += devThorLabs.dbd motorSimSupport.dbd

  $(PROD_NAME)_LIBS := motor $($(PROD_NAME)_LIBS)
  $(PROD_NAME)_LIBS := Acs acsTech80 Aerotech Attocube Faulhaber Ims KohzuMotor $($(PROD_NAME)_LIBS)
  $(PROD_NAME)_LIBS := Mclennan Micos MicroMo NewFocus Newport Oriel PI PIJena $($(PROD_NAME)_LIBS)
  $(PROD_NAME)_LIBS := Parker SmartMotor ThorLabs softMotor motorSimSupport $($(PROD_NAME)_LIBS)
endif

ifdef STREAM
  $(DBD_NAME)_DBD += stream.dbd
  $(PROD_NAME)_LIBS := stream $($(PROD_NAME)_LIBS)
endif

ifdef DEVIOCSTATS
  $(DBD_NAME)_DBD += devIocStats.dbd iocAdmin.dbd
  $(PROD_NAME)_LIBS := devIocStats $($(PROD_NAME)_LIBS)
endif

ifdef ETHERIP
  $(DBD_NAME)_DBD += ether_ip.dbd
  $(PROD_NAME)_LIBS := ether_ip $($(PROD_NAME)_LIBS)
endif

ifdef ALIVE
  ifndef ADCORE
    $(DBD_NAME)_DBD += aliveSupport.dbd
  endif
  $(PROD_NAME)_LIBS := alive $($(PROD_NAME)_LIBS)
endif

ifdef DELAYGEN
  $(DBD_NAME)_DBD += delaygenSupport.dbd
  $(PROD_NAME)_LIBS := delaygen $($(PROD_NAME)_LIBS)
endif

ifdef VAC
  $(DBD_NAME)_DBD += vacSupport.dbd
  $(PROD_NAME)_LIBS := vac $($(PROD_NAME)_LIBS)
endif

#ifdef FLY
#  $(DBD_NAME)_DBD += flySupport.dbd
#  $(PROD_NAME)_LIBS := fly $($(PROD_NAME)_LIBS)
#endif


##################################################################
ifeq ($(OS_CLASS), WIN32) 
  ifdef MEASCOMP
    $(DBD_NAME)_DBD += measCompSupport.dbd
    $(PROD_NAME)_LIBS := measComp $($(PROD_NAME)_LIBS)
    ifeq (win32-x86, $(findstring win32-x86, $(T_A)))
      $(PROD_NAME)_LIBS := cbw32 $($(PROD_NAME)_LIBS)
    else ifeq (windows-x64, $(findstring windows-x64, $(T_A)))
      $(PROD_NAME)_LIBS := cbw64 $($(PROD_NAME)_LIBS)
    endif
  endif

  ifdef MCA
    # If you have installed WinPcap (https://www.winpcap.org) and you want to build
    # Canberra network support uncomment the following lines
    $(DBD_NAME)_DBD += mcaCanberraSupport.dbd
    $(PROD_NAME)_LIBS := mcaCanberra $($(PROD_NAME)_LIBS)
    $(PROD_NAME)_LIBS := wpcap Packet $($(PROD_NAME)_LIBS)

    $(DBD_NAME)_DBD += mcaAmptekSupport.dbd
    $(PROD_NAME)_LIBS := mcaAmptek $($(PROD_NAME)_LIBS)
    $(PROD_NAME)_LIBS := libusb-1.0 $($(PROD_NAME)_LIBS)
  endif

  ifeq (win32-x86,$(findstring win32-x86, $(T_A)))
    ifdef DXP
      # If you want to build parallel port or USB interfaces to Saturn and/or
      # xMAP DXP, then uncomment the following lines
      $(DBD_NAME)_DBD += dxpSupport.dbd
      $(PROD_NAME)_LIBS := dxp handel $($(PROD_NAME)_LIBS)
      $(PROD_NAME)_LIBS := PlxApi $($(PROD_NAME)_LIBS)
      $(PROD_NAME)_SYS_LIBS += setupapi
    endif
  endif
  
  ifdef DXPSITORO
    $(DBD_NAME)_DBD += dxpSITOROSupport.dbd
    $(PROD_NAME)_LIBS := dxpSITORO handelSITORO $($(PROD_NAME)_LIBS)
  endif
endif

##################################################################
ifeq ($(OS_CLASS), vxWorks) 
  ifdef ALLEN_BRADLEY
    $(PROD_NAME)_LIBS := allenBradley $($(PROD_NAME)_LIBS)
  endif

  ifdef VME
    $(DBD_NAME)_DBD += vmeVXSupport.dbd
    $(PROD_NAME)_LIBS := vme $($(PROD_NAME)_LIBS)
  endif

  ifdef STD
    $(DBD_NAME)_DBD += stdVXSupport.dbd
  endif

  ifdef IP
    $(DBD_NAME)_DBD += ipVXSupport.dbd
  endif

  ifdef MCA
    $(DBD_NAME)_DBD += SIS38XXSupport.dbd
    $(DBD_NAME)_DBD += mcaCanberraSupport.dbd
    $(PROD_NAME)_LIBS := SIS38XX $($(PROD_NAME)_LIBS)
    $(PROD_NAME)_LIBS := mcaCanberra $($(PROD_NAME)_LIBS)
  endif

  ifdef IPUNIDIG
    $(DBD_NAME)_DBD += ipUnidigSupport.dbd
    $(PROD_NAME)_LIBS := ipUnidig $($(PROD_NAME)_LIBS)
  endif

  ifdef DAC128V
    $(DBD_NAME)_DBD += dac128VSupport.dbd
    $(PROD_NAME)_LIBS := dac128V $($(PROD_NAME)_LIBS)
  endif

  ifdef IP330
    $(DBD_NAME)_DBD += ip330Support.dbd
    $(PROD_NAME)_LIBS := ip330 $($(PROD_NAME)_LIBS)
  endif

  ifdef CAMAC
    $(DBD_NAME)_DBD += camacSupport.dbd
    $(DBD_NAME)_DBD += devCamacSupport.dbd
    $(PROD_NAME)_LIBS := camac devCamac $($(PROD_NAME)_LIBS)
  endif

  ifdef ALLEN_BRADLEY
    $(DBD_NAME)_DBD += allenBradley.dbd
  endif

  ifdef LOVE
    $(DBD_NAME)_DBD += devLove.dbd
    $(PROD_NAME)_LIBS := love $($(PROD_NAME)_LIBS)
  endif

  ifdef IPAC
    $(DBD_NAME)_DBD += tyGSOctal.dbd
    $(DBD_NAME)_DBD += drvIpac.dbd
    $(PROD_NAME)_LIBS := TyGSOctal Ipac $($(PROD_NAME)_LIBS)
    $(DBD_NAME)_DBD += IP520.dbd
    $(PROD_NAME)_LIBS := IP520 $($(PROD_NAME)_LIBS)
  endif

  ifdef ASYN
    $(DBD_NAME)_DBD += drvGsIP488.dbd
  endif

  ifdef SOFTGLUE
    $(DBD_NAME)_DBD += softGlueSupport.dbd
    $(PROD_NAME)_LIBS := softGlue $($(PROD_NAME)_LIBS)
  endif

  ifdef MOTOR
    $(DBD_NAME)_DBD += devDeltaTau.dbd
    $(DBD_NAME)_DBD += devOms.dbd
    $(PROD_NAME)_LIBS := oms DeltaTau $($(PROD_NAME)_LIBS)
  endif

#  ifdef FLY
#    $(DBD_NAME)_DBD += flyVXSupport.dbd
#    $(PROD_NAME)_LIBS := fly $($(PROD_NAME)_LIBS)
#  endif

endif

##################################################################
ifeq ($(OS_CLASS), Linux) 
  ifdef DXP
    # If your host supports parallel port or USB interfaces to Saturn DXP, set
    # LINUX_USB_INSTALLED to YES in <synApps>/configure/CONFIG_SITE.
    ifeq ($(LINUX_USB_INSTALLED), YES)
      $(DBD_NAME)_DBD += dxpSupport.dbd
      $(PROD_NAME)_LIBS  := dxp handel $($(PROD_NAME)_LIBS)
      $(PROD_NAME)_SYS_LIBS += usb 
    endif
  endif

  ifdef MCA
    # If your host supports libpcap and libnet and you want to build Canberra network
    # support, set LINUX_NET_INSTALLED to YES in <synApps>/configure/CONFIG_SITE.
    ifeq ($(LINUX_NET_INSTALLED), YES)
      $(DBD_NAME)_DBD += mcaCanberraSupport.dbd
      $(PROD_NAME)_LIBS := mcaCanberra $($(PROD_NAME)_LIBS)
      $(PROD_NAME)_SYS_LIBS += net pcap
    endif

    # If your host supports libusb-1.0 and you want to build Amptek
    # support, set LINUX_USB-1.0_INSTALLED to YES in <synApps>/configure/CONFIG_SITE.
    ifeq ($(LINUX_USB-1.0_INSTALLED), YES)
      $(DBD_NAME)_DBD += mcaAmptekSupport.dbd
      $(PROD_NAME)_LIBS := mcaAmptek $($(PROD_NAME)_LIBS)
      $(PROD_NAME)_SYS_LIBS += usb-1.0
    endif
  endif

  ifdef IPAC
    $(DBD_NAME)_DBD += drvIpac.dbd
    $(PROD_NAME)_LIBS := Ipac $($(PROD_NAME)_LIBS)
  endif

  ifdef IPUNIDIG
    $(DBD_NAME)_DBD += ipUnidigSupport.dbd
    $(PROD_NAME)_LIBS := ipUnidig $($(PROD_NAME)_LIBS)
  endif

  ifdef DAC128V
    $(DBD_NAME)_DBD += dac128VSupport.dbd
    $(PROD_NAME)_LIBS := dac128V $($(PROD_NAME)_LIBS)
  endif

  ifdef IP330
    $(DBD_NAME)_DBD += ip330Support.dbd
    $(PROD_NAME)_LIBS := ip330 $($(PROD_NAME)_LIBS)
  endif

  ifdef SOFTGLUE
    $(DBD_NAME)_DBD += softGlueSupport.dbd
    $(PROD_NAME)_LIBS := softGlue $($(PROD_NAME)_LIBS)
  endif
  
  ifdef SOFTGLUEZYNQ
    $(DBD_NAME)_DBD += softGlueZynqSupport.dbd
    $(PROD_NAME)_LIBS := softGlueZynq $($(PROD_NAME)_LIBS)
  endif
    
  ifdef YOKOGAWA_DAS
    $(DBD_NAME)_DBD += mw100Support.dbd
    $(PROD_NAME)_LIBS := mw100 $($(PROD_NAME)_LIBS)
  endif
endif

$(PROD_NAME)_LIBS += $(EPICS_BASE_IOC_LIBS)

# <name>_registerRecordDeviceDriver.cpp will be created from <name>.dbd
ifeq ($(OS_CLASS), vxWorks) 
  $(PROD_NAME)_SRCS  += $(DBD_NAME)_registerRecordDeviceDriver.cpp
else
  $(PROD_NAME)_SRCS  += $(DBD_NAME)_registerRecordDeviceDriver.cpp $(PROD_NAME)Main.cpp
endif

#The following adds support from base/src/vxWorks
$(PROD_NAME)_OBJS_vxWorks += $(EPICS_BASE_BIN)/vxComLibrary

# Here's how to print out all gnumake variables
#$(foreach v, $(.VARIABLES), $(info $(v) = $($(v))))
# print out just one variable
#$(info SUPPORT = $(SUPPORT))

#===========================

include $(TOP)/configure/RULES
#----------------------------------------
#  ADD RULES AFTER THIS LINE
