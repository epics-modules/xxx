#!/bin/bash

EPICS_APP=/home/oxygen/MOONEY/epics/synApps_5_5/support/xxx

output=`perl -s $EPICS_APP/release.pl -form=bash $EPICS_APP`
eval $output

#####################
# prepare MEDM path
#
EDP=.
EDP=$EDP:$EPICS_APP/xxxApp/op/adl
EDP=$EDP:$AREA_DETECTOR/ADApp/op/adl
EDP=$EDP:$AUTOSAVE/asApp/op/adl
EDP=$EDP:$BUSY/busyApp/op/adl
EDP=$EDP:$CALC/calcApp/op/adl
EDP=$EDP:$CAMAC/camacApp/op/adl
EDP=$EDP:$DAC128V/dac128VApp/op/adl
EDP=$EDP:$DELAYGEN/delaygenApp/op/adl
EDP=$EDP:$DXP/dxpApp/op/adl
EDP=$EDP:$IP/ipApp/op/adl
EDP=$EDP:$IP330/ip330App/op/adl
EDP=$EDP:$IPUNIDIG/ipUnidigApp/op/adl
EDP=$EDP:$LOVE/loveApp/op/adl
EDP=$EDP:$MCA/mcaApp/op/adl
EDP=$EDP:$MOTOR/motorApp/op/adl
EDP=$EDP:$OPTICS/opticsApp/op/adl
EDP=$EDP:$QUADEM/quadEMApp/op/adl
EDP=$EDP:$SSCAN/sscanApp/op/adl
EDP=$EDP:$STD/stdApp/op/adl
EDP=$EDP:$VME/vmeApp/op/adl
EDP=$EDP:$ASYN/medm
EDP=$EDP:$VAC/vacApp/op/adl
EDP=$EDP:$SOFTGLUE/softGlueApp/op/adl

if [ -z "$EPICS_DISPLAY_PATH" ] 
then
    export EPICS_DISPLAY_PATH=$EDP
else
    export EPICS_DISPLAY_PATH=$EDP:$EPICS_DISPLAY_PATH
fi
echo $EPICS_DISPLAY_PATH

if [ -z "$MEDM_EXEC_LIST" ] 
then
export MEDM_EXEC_LIST='Probe;probe &P &'
fi

#export EPICS_CA_ADDR_LIST="164.54.53.126"

# This should agree with the environment variable set by the ioc
# see 'putenv "EPICS_CA_MAX_ARRAY_BYTES=64008"' in iocBoot/ioc<target>/st.cmd
export EPICS_CA_MAX_ARRAY_BYTES=64008

cd $EPICS_APP/xxxApp/op/adl
medm xxx.adl&
