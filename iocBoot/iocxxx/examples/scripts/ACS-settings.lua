-- ACS Motion controller settings file
--
-- This file defines the per-axis configuration for an ACS Motion
-- SPiiPlus controller. Copy this file, rename it, and edit the
-- motor list below to match your hardware.
--
-- Usage (in motors.iocsh or st.cmd):
--   luaLoadFile("scripts/ACS_MP4U.lua", "PREFIX=$(PREFIX), INSTANCE=ACS1, MOTOR_SETTINGS='settings/ACS1', IP_ADDR=10.0.0.100")
--
-- Values set at the top level (outside the motor list) serve as
-- defaults for all motors. Individual motors can override any
-- default by specifying the field in their entry.

return {
	-- Section-level defaults (override script defaults for all motors)
	--
	-- General:
	--! NPOINTS = 2000,         -- Profile move points
	--! NPULSES = 2000,         -- Defaults to NPOINTS
	--! NREADBACK = 2000,       -- Defaults to NPOINTS
	--! TIMEOUT = 2.0,          -- Timeout for asyn communication
	--
	-- Motor record fields:
	--! M = "m$(N)",            -- Motor record name
	--! DTYP = "asynMotor",     -- Device type
	--! DESC = "motor $(N)",    -- Description
	--! EGU = "mm",             -- Engineering units
	--! DIR = "Pos",            -- Direction
	--! VELO = 1,               -- Velocity
	--! VBAS = 0.1,             -- Base velocity
	--! ACCL = 0.2,             -- Acceleration time
	--! BDST = 0,               -- Backlash distance
	--! BVEL = 1,               -- Backlash velocity
	--! BACC = 0.2,             -- Backlash acceleration
	--! SREV = 200,             -- Steps per revolution
	--! MRES = 0.0001,          -- Motor resolution
	--! ERES = 0.0001,          -- Encoder resolution (defaults to MRES)
	--! PREC = 4,               -- Display precision (auto-computed from MRES if not set)
	--! DHLM = 100,             -- Dial high limit
	--! DLLM = 100,             -- Dial low limit
	--! INIT = "",              -- Init string
	--! UEIP = 0,               -- Use encoder if present (set to 1 if ABSOLUTE is true)
	--! ABSOLUTE = false,       -- Absolute encoder (loads SPiiPlusDisableSetPos.db, sets UEIP=1)
	--! HOMING = 0,             -- Homing method (0 = none)
	--
	-- Max parameters:
	--! MAX_VELO = 200.0,       -- Maximum velocity
	--! MAX_ACCL = 1000.0,      -- Maximum acceleration

	SREV = 2000,    -- 10:1 microstepping on all motors

	-- Motor list: set individual motor values here.
	-- Only specify fields that differ from the defaults above.
	-- N is the axis number (1-based), ADDR is computed as N-1.
	{N = 1,  DESC = "Sample X",   EGU = "mm",  MRES = 0.0001,  ERES = 0.000005,   ABSOLUTE = true,  MAX_VELO = 5.0, MAX_ACCL = 20.0},
	{N = 2,  DESC = "Sample Y",   EGU = "mm",  MRES = 0.0002,  ERES = 0.000005,   ABSOLUTE = true,  MAX_VELO = 5.0, MAX_ACCL = 20.0},
	{N = 3,  DESC = "Sample Z",   EGU = "mm",  MRES = 0.000125,                    ABSOLUTE = true},
	{N = 4,  DESC = "Theta",      EGU = "deg", MRES = 0.00005, ERES = 0.000000084, ABSOLUTE = true},
	{N = 5,  DESC = "Phi",        EGU = "deg", MRES = 0.00005,                                       SREV = 4000},
	{N = 6,  DESC = "Slit Top",   EGU = "mm",  MRES = 0.0001},
	{N = 7,  DESC = "Slit Bottom", EGU = "mm", MRES = 0.0001},
	{N = 8,  DESC = "Slit Left",  EGU = "mm",  MRES = 0.0001},
}
