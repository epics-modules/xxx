#!/bin/env python

# examples of recorded macros (doScan) and recorded macros that have been edited
# to use arguments (initScanDo, motorscan)

import time
import epics

# The function "_abort" is special: it's used by caputRecorder.py to abort an
# executing macro
def _abort(prefix):
	print "aborting"
	epics.caput(prefix+"AbortScans", "1")
	epics.caput(prefix+"allstop", "stop")
	epics.caput(prefix+"scaler1.CNT", "Done")

def doScan():
	recordDate = "Mon Jan  5 13:44:08 2015"
	epics.caput("xxx:scan1.P1PV","xxx:m2.VAL", wait=True, timeout=300)
	epics.caput("xxx:scan1.P1SP","0.00000", wait=True, timeout=300)
	epics.caput("xxx:scan1.P1EP","1.00000", wait=True, timeout=300)
	epics.caput("xxx:scan1.P1SI","0.10000", wait=True, timeout=300)
	epics.caput("xxx:scan1.D01PV","xxx:userCalcOut1.VAL", wait=True, timeout=300)
	epics.caput("xxx:scan1.EXSC","1", wait=True, timeout=300)

def initScanDo(start=0, end=1):
	epics.caput("xxx:scan1.NPTS","21", wait=True, timeout=300)
	epics.caput("xxx:scan1.P1PV","xxx:m1.VAL", wait=True, timeout=300)
	epics.caput("xxx:scan1.P1SP",start, wait=True, timeout=300)
	epics.caput("xxx:scan1.P1EP",end, wait=True, timeout=300)
	epics.caput("xxx:scan1.P1SM","LINEAR", wait=True, timeout=300)
	epics.caput("xxx:scan1.P1AR","ABSOLUTE", wait=True, timeout=300)
	epics.caput("xxx:scan1.PASM","STAY", wait=True, timeout=300)
	epics.caput("xxx:scan1.T1PV","xxx:scaler1.CNT", wait=True, timeout=300)
	epics.caput("xxx:scan1.D01PV","xxx:userCalcOut1.VAL", wait=True, timeout=300)
	epics.caput("xxx:scan1.EXSC","1", wait=True, timeout=3)

def motorscan(motor="m1", start=0, end=1, step=.1):
	epics.caput("xxx:scan1.P1PV",("xxx:%s.VAL" % motor), wait=True, timeout=300)
	epics.caput("xxx:scan1.P1SP",start, wait=True, timeout=300)
	epics.caput("xxx:scan1.P1EP",end, wait=True, timeout=300)
	epics.caput("xxx:scan1.P1SI",step, wait=True, timeout=300)
	# example of time delay
	time.sleep(3)
	epics.caput("xxx:scan1.EXSC","1", wait=True, timeout=300)




