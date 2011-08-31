#!/bin/bash

EPICS_APP=/home/oxygen/MOONEY/epics/synApps_5_5/support/xxx
EPICS_APP_ADL_DIR=${EPICS_APP}/xxxApp/op/adl

output=`perl -s ${EPICS_APP}/release.pl -form=bash ${EPICS_APP}`
eval $output

#######################################
# Prepare MEDM path
# EDP is temporary EPICS_DISPLAY_PATH
#
function append_EDP { # note: in bash, macros are not expanded in aliases
  if [ -d $1 ]  # this will keep keep out nonexistent directories
  then
    EDP=${EDP}:$1
  fi
}
EDP=.
append_EDP  ${EPICS_APP_ADL_DIR}
append_EDP  ${AREA_DETECTOR}/ADApp/op/adl
append_EDP  ${AUTOSAVE}/asApp/op/adl
append_EDP  ${BUSY}/busyApp/op/adl
append_EDP  ${CALC}/calcApp/op/adl
append_EDP  ${CAMAC}/camacApp/op/adl
append_EDP  ${DAC128V}/dac128VApp/op/adl
append_EDP  ${DELAYGEN}/delaygenApp/op/adl
append_EDP  ${DXP}/dxpApp/op/adl
append_EDP  ${IP}/ipApp/op/adl
append_EDP  ${IP330}/ip330App/op/adl
append_EDP  ${IPUNIDIG}/ipUnidigApp/op/adl
append_EDP  ${LOVE}/loveApp/op/adl
append_EDP  ${MCA}/mcaApp/op/adl
append_EDP  ${MOTOR}/motorApp/op/adl
append_EDP  ${OPTICS}/opticsApp/op/adl
append_EDP  ${QUADEM}/quadEMApp/op/adl
append_EDP  ${SSCAN}/sscanApp/op/adl
append_EDP  ${STD}/stdApp/op/adl
append_EDP  ${VME}/vmeApp/op/adl
append_EDP  ${ASYN}/medm
append_EDP  ${VAC}/vacApp/op/adl
append_EDP  ${SOFTGLUE}/softGlueApp/op/adl

if [ -z "$EPICS_DISPLAY_PATH" ] 
then
    export EPICS_DISPLAY_PATH=${EDP}
else
    export EPICS_DISPLAY_PATH=${EDP}:${EPICS_DISPLAY_PATH}
fi
echo ${EPICS_DISPLAY_PATH}

if [ -z "${MEDM_EXEC_LIST}" ] 
then
    export MEDM_EXEC_LIST='Probe;probe &P &'
fi

#export EPICS_CA_ADDR_LIST="164.54.53.126"

# This should agree with the environment variable set by the ioc
# see 'putenv "EPICS_CA_MAX_ARRAY_BYTES=64008"' in iocBoot/ioc<target>/st.cmd
export EPICS_CA_MAX_ARRAY_BYTES=64008

cd ${EPICS_APP}/xxxApp/op/adl
medm xxx.adl&
