-- ACS_MP4U.lua
--
-- Lua-based loader for ACS Motion SPiiPlus motor controllers.
-- Uses a settings file for per-axis configuration instead of
-- large substitution files.
--
-- Parameters (passed via luaLoadFile macros):
--   PREFIX         - IOC prefix (e.g., "xxx:")
--   INSTANCE       - Controller instance name (e.g., "ACS1")
--   MOTOR_SETTINGS - Path to settings file (e.g., "settings/ACS1")
--   IP_ADDR        - IP address of the controller (default: "10.0.0.100")
--   PORT           - TCP port (default: 701)
--   POLL_PERIOD    - Motor poll period in seconds (default: 0.1)
--   MOVING_POLL    - Moving poll period (default: POLL_PERIOD)
--   IDLE_POLL      - Idle poll period (default: POLL_PERIOD)
--
-- Usage:
--   luaLoadFile("scripts/ACS_MP4U.lua", "PREFIX=$(PREFIX), INSTANCE=ACS1, MOTOR_SETTINGS='settings/ACS1', IP_ADDR=10.0.0.100")

local db = require("db")
local settings = require("settings")

-- Setting defaults for motor axes
local defaults = {
	NPOINTS = 2000,
	NPULSES = -1,
	NREADBACK = -1,
	TIMEOUT = 2.0,

	M = "m$(N)",
	DTYP = "asynMotor",
	DESC = "motor $(N)",
	EGU = "mm",
	DIR = "Pos",
	VELO = 1,
	VBAS = 0.1,
	ACCL = 0.2,
	BDST = 0,
	BVEL = 1,
	BACC = 0.2,
	SREV = 200,
	MRES = 0.0001,
	ERES = -1,
	PREC = -1,
	DHLM = 100,
	DLLM = 100,
	INIT = "",
	UEIP = 0,
	ABSOLUTE = false,
	HOMING = 0,
	MAX_VELO = 200.0,
	MAX_ACCL = 1000.0,
}

-- Validate required parameters
if not INSTANCE then
	error("ACS_MP4U: INSTANCE parameter is required")
end

if not MOTOR_SETTINGS then
	error("ACS_MP4U: MOTOR_SETTINGS parameter is required (path to settings file)")
end

-- Script defaults
POLL_PERIOD = POLL_PERIOD or 0.1
MOVING_POLL = MOVING_POLL or POLL_PERIOD
IDLE_POLL   = IDLE_POLL or POLL_PERIOD
IP_ADDR = IP_ADDR or "10.0.0.100"
PORT = PORT or 701


-- Load Motor Settings
local acs = settings.load(MOTOR_SETTINGS, defaults)

-- Setup ACS Driver
drvAsynIPPortConfigure(INSTANCE .. "_ETH", ("%s:%s"):format(IP_ADDR, PORT), 0, 0, 0)
asynOctetSetInputEos(INSTANCE .. "_ETH", -1, "\r")
asynOctetSetOutputEos(INSTANCE .. "_ETH", -1, "\r")

AcsMotionConfig(INSTANCE, INSTANCE .. "_ETH", #acs, MOVING_POLL, IDLE_POLL, "")
SPiiPlusCreateProfile(INSTANCE, acs.NPOINTS)

local basic_macros = { P= PREFIX .. INSTANCE .. ":", PORT= INSTANCE, "N", "M", "ADDR", "PREC" }
local all_macros = { basic_macros, {"DTYP", "DESC", "EGU", "DIR", "VELO", "VBAS", "ACCL", "BDST", "BVEL", "BACC", "SREV", "MRES", "DHLM", "DLLM", "INIT"}}

for index, axis in ipairs(acs) do
	-- Adjust for referential values
	if axis.ERES < 0      then axis.ERES = axis.MRES end
	if axis.NPULSES < 0   then axis.NPULSES = axis.NPOINTS end
	if axis.NREADBACK < 0 then axis.NREADBACK = axis.NPOINTS end
	if axis.ADDR == nil   then axis.ADDR = axis.N - 1 end

	if axis.PREC < 0 then
		-- Auto-compute precision from MRES significant digits
		local s = string.format("%g", axis.MRES)
		local dec = s:match("%.(%d+)$")
		local sci = s:match("e%-(%d+)$")

		if sci then
			axis.PREC = tonumber(sci)
		elseif dec then
			axis.PREC = #dec
		else
			axis.PREC = 0
		end
	end

	-- Load Records
	dbLoadRecords("$(MOTOR)/db/asyn_motor.db",            axis:macros(all_macros))
	dbLoadRecords("$(MOTOR)/db/SPiiPlusAxisExtra.db",     axis:macros(basic_macros))
	dbLoadRecords("$(MOTOR)/db/SPiiPlusJogging.db",       axis:macros(basic_macros))
	dbLoadRecords("$(MOTOR)/db/SPiiPlusMaxParams.db",     axis:macros{basic_macros, {"MAX_VELO", "MAX_ACCL"}})
	dbLoadRecords("$(MOTOR)/db/SPiiPlusMaxParamsRbv.db",  axis:macros(basic_macros))
	dbLoadRecords("$(MOTOR)/db/SPiiPlusHoming.db",        axis:macros{basic_macros, {"TIMEOUT", VAL=axis.HOMING, MAX_DIST=0.0, OFFSET_POS=0.0, OFFSET_NEG=0.0}})
	dbLoadRecords("$(MOTOR)/db/profileMoveAxis.template", axis:macros{basic_macros, {R="pm:", "NPOINTS", "NREADBACK", "TIMEOUT"}})

	if axis.ABSOLUTE then
		dbLoadRecords("$(MOTOR)/db/SPiiPlusDisableSetPos.db", axis:macros(basic_macros))
		axis.UEIP = 1
	end

	if axis.UEIP ~= 0 then
		dbLoadRecords("$(MOTOR)/db/SPiiPlusFeedback.db", axis:macros(basic_macros))
	end

	local motor_name = string.gsub(PREFIX .. INSTANCE .. ":" .. axis.M, "%$%(N%)", axis.N)

	db.record("motor", motor_name) {
		ERES = axis.ERES,
		UEIP = axis.UEIP,
		SREV = axis.SREV,
	}
end

dbLoadRecords("$(MOTOR)/db/profileMoveController.template", acs:macros{P= PREFIX..INSTANCE, PORT=INSTANCE, R="pm:", NAXES=#acs, "NPOINTS", "NPULSES", "TIMEOUT"})
