#!/bin/env python

import epics

# The function "_abort" is special: it's used by asTrap to abort an executing
# macro
def _abort(prefix):
	print "aborting"
	epics.caput(prefix+"AbortScans", "1")
	epics.caput(prefix+"allstop", "stop")
	epics.caput(prefix+"scaler1.CNT", "Done")

def initScan(start=0, end=1):
	epics.caput("xxx:scan1.T1PV","xxx:scaler1.CNT")
	epics.caput("xxx:scan1.NPTS","21")
	epics.caput("xxx:scan1.P1PV","xxx:m1.VAL")
	epics.caput("xxx:scan1.P1SP",start)
	epics.caput("xxx:scan1.P1EP",end)
	epics.caput("xxx:scan1.P1SM","LINEAR")
	epics.caput("xxx:scan1.P1AR","ABSOLUTE")
	epics.caput("xxx:scan1.PASM","STAY")
	epics.caput("xxx:scan1.T1PV","xxx:scaler1.CNT")
	epics.caput("xxx:scan1.D01PV","xxx:userCalcOut1.VAL")

def initScaler():
	epics.caput("xxx:scaler1.CONT","OneShot")
	epics.caput("xxx:scaler1.TP","1.000")
	epics.caput("xxx:scaler1.TP1","1.000")
	epics.caput("xxx:scaler1.RATE","10.000")
	epics.caput("xxx:scaler1.DLY","0.000")
	epics.caput("xxx:scaler1_calcEnable.VAL","ENABLE")

def initScanDo(start=0, end=1, d1=1,d2=2,d3=3,d4=4):
	epics.caput("xxx:scan1.NPTS","21", wait=True, timeout=300)
	epics.caput("xxx:scan1.P1PV","xxx:m1.VAL", wait=True, timeout=300)
	epics.caput("xxx:scan1.P1SP",start, wait=True, timeout=300)
	epics.caput("xxx:scan1.P1EP",end, wait=True, timeout=300)
	epics.caput("xxx:scan1.P1SM","LINEAR", wait=True, timeout=300)
	epics.caput("xxx:scan1.P1AR","ABSOLUTE", wait=True, timeout=300)
	epics.caput("xxx:scan1.PASM","STAY", wait=True, timeout=300)
	epics.caput("xxx:scan1.T1PV","xxx:scaler1.CNT", wait=True, timeout=300)
	epics.caput("xxx:scan1.D01PV","xxx:userCalcOut1.VAL", wait=True, timeout=300)
	epics.caput("xxx:scan1.EXSC","1", wait=True, timeout=300)
	epics.caput("xxx:scan1.EXSC","1", wait=True, timeout=300)

def motorscan(motor="m1", start=0, end=1, step=.1):
	epics.caput("xxx:scan1.P1PV",("xxx:%s.VAL" % motor), wait=True, timeout=300)
	epics.caput("xxx:scan1.P1SP",start, wait=True, timeout=300)
	epics.caput("xxx:scan1.P1EP",end, wait=True, timeout=300)
	epics.caput("xxx:scan1.P1SI",step, wait=True, timeout=300)
	epics.caput("xxx:scan1.EXSC","1", wait=True, timeout=300)

def test1():
	recordDate = "Mon Dec 22 17:12:27 2014"
	# test1
	epics.caput("xxx:scan1.P1PV","xxx:m2.VAL", wait=True, timeout=300)
	epics.caput("xxx:scan1.D01PV","xxx:userCalcOut1.VAL", wait=True, timeout=300)

def test2():
	recordDate = "Sun Dec 28 16:26:53 2014"
	epics.caput("xxx:scan1.P1PV","xxx:m2.VAL", wait=True, timeout=300)
	epics.caput("xxx:scan1.P1SP","0.00000", wait=True, timeout=300)
	epics.caput("xxx:scan1.P1EP","1.00000", wait=True, timeout=300)
	epics.caput("xxx:scan1.P1SI","0.10000", wait=True, timeout=300)
	epics.caput("xxx:scan1.D01PV","xxx:userCalcOut1.VAL", wait=True, timeout=300)
	epics.caput("xxx:scan1.EXSC","1", wait=True, timeout=300)

