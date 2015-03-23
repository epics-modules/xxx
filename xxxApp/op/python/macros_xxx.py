#!/bin/env python

# examples of recorded macros, and recorded macros that have been edited
# to use arguments

import os
import time
import epics

# The function "_abort" is special: it's used by caputRecorder.py to abort an
# executing macro
def _abort(prefix):
	print "%s.py: _abort() prefix=%s" % (__name__, prefix)
	epics.caput(prefix+"AbortScans", "1")
	epics.caput(prefix+"allstop", "stop")
	epics.caput(prefix+"scaler1.CNT", "Done")

	epics.caput("yyy:"+"AbortScans", "1")
	epics.caput("yyy:"+"allstop", "stop")
	epics.caput("yyy:"+"scaler1.CNT", "Done")

def motorscan(motor="m1", start=0, end=1, npts=11):
	epics.caput("xxx:scan1.P1PV",("xxx:%s.VAL" % motor), wait=True, timeout=1000000.0)
	epics.caput("xxx:scan1.P1SP",start, wait=True, timeout=1000000.0)
	epics.caput("xxx:scan1.P1EP",end, wait=True, timeout=1000000.0)
	epics.caput("xxx:scan1.NPTS",npts, wait=True, timeout=1000000.0)
	# example of time delay
	time.sleep(.1)
	epics.caput("xxx:scan1.EXSC","1", wait=True, timeout=1000000.0)

def flyscan(motor='yyy:m1',start=0.0,end=3.14,npts=100,dwell=.2,scaler='yyy:scaler1'):
	recordDate = "Sun Mar  1 21:28:45 2015"
	# save prev speed
	oldSpeed = epics.caget(motor+".VELO")
	maxSpeed = epics.caget(motor+".VMAX")
	baseSpeed = epics.caget(motor+".VBAS")
	accelTime = epics.caget(motor+".ACCL")
	if maxSpeed == 0: maxSpeed = oldSpeed

	# send motor to start at normal speed
	epics.caput(motor+".VAL",start, wait=True, timeout=1000000.0)
	epics.caput("xxx:scan1.R1PV",motor+".RBV", wait=True, timeout=1000000.0)
	epics.caput("xxx:scan1.P1PV",motor+".VAL", wait=True, timeout=1000000.0)
	epics.caput("xxx:scan1.P1SP",start, wait=True, timeout=1000000.0)
	epics.caput("xxx:scan1.P1EP",end, wait=True, timeout=1000000.0)
	epics.caput("xxx:scan1.NPTS",npts, wait=True, timeout=1000000.0)
	epics.caput("xxx:scan1.T1PV",scaler+".CNT", wait=True, timeout=1000000.0)
	epics.caput("xxx:scan1.D01PV",scaler+".S1", wait=True, timeout=1000000.0)
	epics.caput("xxx:scan1.D02PV",scaler+".S2", wait=True, timeout=1000000.0)
	epics.caput("xxx:scan1.P1SM","FLY", wait=True, timeout=1000000.0)
	epics.caput("xxx:scan1.P1AR","ABSOLUTE", wait=True, timeout=1000000.0)
	epics.caput(scaler+".TP",dwell, wait=True, timeout=1000000.0)
	#epics.caput("xxx:scan1.PASM","STAY", wait=True, timeout=1000000.0)

	# calc speed including accelTime and baseSpeed
	totalTime = npts*dwell
	totalDist = abs(end-start)
	if totalTime > 2*accelTime:
		speed = (totalDist - accelTime*baseSpeed) / (totalTime - accelTime)
	else:
		speed = 2*totalDist/totalTime - baseSpeed

	if speed <= baseSpeed:
		print "desired speed=%f less than base speed %f" % (speed, baseSpeed)
		speed = baseSpeed+.01
	if speed > maxSpeed:
		print "desired speed=%f greater than max speed %f" %(speed, maxSpeed)
		speed = maxSpeed

	#print "speed=%f" % speed
	epics.caput(motor+".VELO",speed, wait=True, timeout=1000000.0)
	epics.caput("xxx:scan1.EXSC","1", wait=True, timeout=1000000.0)
	epics.caput(motor+".VELO",oldSpeed, wait=True, timeout=1000000.0)


def copyMotorSettings(fromMotor="xxx:m1", toMotor="xxx:m2"):
	motorFields = [".MRES", ".ERES", ".RRES", ".SREV", ".DIR", ".DHLM", ".DLLM", ".TWV",  
	".VBAS", ".VELO", ".ACCL", ".BDST", ".BVEL", ".BACC", ".RDBD", ".DESC",
	".EGU", ".RTRY", ".UEIP", ".URIP", ".DLY", ".RDBL", ".PREC", ".DISA",
	".DISP", ".FOFF", ".OFF", ".FRAC", ".OMSL", ".JVEL", ".JAR", ".VMAX",
	".PCOF", ".ICOF", ".DCOF", ".HVEL", ".NTM", ".NTMF", ".INIT", ".PREM",
	".POST", ".FLNK", ".RMOD"]
	for field in motorFields:
		val = epics.caget(fromMotor+field)
		epics.caput(toMotor+field, val)

def getDbd(prefix="xxx:"):
	a1 = epics.caget(prefix+"APP_DIR1")
	a2 = epics.caget(prefix+"APP_DIR2")
	appDir = a1+a2
	s1 = epics.caget(prefix+"ST_SCRIPT1")
	s2 = epics.caget(prefix+"ST_SCRIPT2")
	startupScript=os.path.join(s1+s2, "st.cmd")
	startupFile = open(startupScript)
	lines = startupFile.readlines()
	startupFile.close()

	dbdFile = None
	for line in lines:
		line = line.strip()
		if line.startswith("dbLoadDatabase"):
			print "line = ", line
			startIx = line.index('"')+1
			endIx = line.rindex('"')
			dbdFileName = os.path.basename(line[startIx:endIx])
			dbdFilePath = os.path.dirname(os.path.dirname(appDir))
			dbdFilePath = os.path.join(dbdFilePath,"dbd")
			dbdFilePath = os.path.join(dbdFilePath, dbdFileName)
			print "dbdFilePath = ", dbdFilePath

def backforth():
	recordDate = "Tue Mar 17 21:07:47 2015"
	epics.caput("xxx:m1.TWF","1", wait=True, timeout=1000000.0)
	epics.caput("xxx:m1.TWR","1", wait=True, timeout=1000000.0)

def backforthM(motor="xxx:m1"):
	recordDate = "Tue Mar 17 21:07:47 2015"
	epics.caput(motor+".TWF","1", wait=True, timeout=1000000.0)
	epics.caput(motor+".TWR","1", wait=True, timeout=1000000.0)

def testInclude():
	recordDate = "Wed Mar 18 14:08:42 2015"
	epics.caput("xxx:m2.TWF","1", wait=True, timeout=1000000.0)
	backforth()
	epics.caput("xxx:m2.TWR","1", wait=True, timeout=1000000.0)
	backforth()



