#!/bin/env python

# examples of recorded macros, and recorded macros that have been edited
# to use arguments

import time
import epics

# The function "_abort" is special: it's used by caputRecorder.py to abort an
# executing macro
def _abort(prefix):
	print "aborting"
	epics.caput(prefix+"AbortScans", "1")
	epics.caput(prefix+"allstop", "stop")
	epics.caput(prefix+"scaler1.CNT", "Done")

def motorscan(motor="m1", start=0, end=1, npts=11):
	epics.caput("xxx:scan1.P1PV",("xxx:%s.VAL" % motor), wait=True, timeout=-1)
	epics.caput("xxx:scan1.P1SP",start, wait=True, timeout=-1)
	epics.caput("xxx:scan1.P1EP",end, wait=True, timeout=-1)
	epics.caput("xxx:scan1.NPTS",npts, wait=True, timeout=-1)
	# example of time delay
	time.sleep(.1)
	epics.caput("xxx:scan1.EXSC","1", wait=True, timeout=-1)

def flyscan(motor='xxx:m1',start=0.0,end=1.0,npts=100,dwell=.2,scaler='xxx:scaler1'):
	recordDate = "Sun Mar  1 21:28:45 2015"
	# save prev speed
	oldspeed = epics.caget(motor+".VELO")
	maxspeed = epics.caget(motor+".VMAX")
	basespeed = epics.caget(motor+".VBAS")
	if maxspeed == 0: maxspeed = oldspeed

	# send motor to start at normal speed
	epics.caput(motor+".VAL",start, wait=True, timeout=-1.0)
	epics.caput("xxx:scan1.R1PV",motor+".RBV", wait=True, timeout=-1.0)
	epics.caput("xxx:scan1.P1PV",motor+".VAL", wait=True, timeout=-1.0)
	epics.caput("xxx:scan1.P1SP",start, wait=True, timeout=-1.0)
	epics.caput("xxx:scan1.P1EP",end, wait=True, timeout=-1.0)
	epics.caput("xxx:scan1.NPTS",npts, wait=True, timeout=-1.0)
	epics.caput("xxx:scan1.T1PV",scaler+".CNT", wait=True, timeout=-1.0)
	epics.caput("xxx:scan1.D01PV",scaler+".S1", wait=True, timeout=-1.0)
	epics.caput("xxx:scan1.D02PV",scaler+".S2", wait=True, timeout=-1.0)
	epics.caput("xxx:scan1.P1SM","FLY", wait=True, timeout=-1.0)
	epics.caput("xxx:scan1.P1AR","ABSOLUTE", wait=True, timeout=-1.0)
	epics.caput(scaler+".TP",dwell, wait=True, timeout=-1.0)
	epics.caput("xxx:scan1.PASM","STAY", wait=True, timeout=-1.0)
	speed = abs(end-start)/(dwell*npts)
	speed = max(basespeed,min(speed, maxspeed))
	#print "speed=%f" % speed
	epics.caput(motor+".VELO",speed, wait=True, timeout=-1.0)
	epics.caput("xxx:scan1.EXSC","1", wait=True, timeout=-1.0)
	epics.caput(motor+".VELO",oldspeed, wait=True, timeout=-1.0)

