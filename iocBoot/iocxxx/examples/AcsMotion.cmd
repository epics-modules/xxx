#- PREFIX    - IOC Prefix
#- INSTANCE  - MP4U Prefix
#- NUM_AXES  - Number of motors MP4U is specc'd for (Default is 32)
#- NUM_CHAN   - Number of IO channels (Default is 32)
#- IP_ADDR   - IP Address of the MP4U
#- SUB       - Motor substitutions file (Default is substitutions/$(INSTANCE).substitutions)
#- IO_SUB    - IO substitutions file (Default is substitutions/$(INSTANCE)_IO.substitutions)

#- POLL_PERIOD    - Optional: Motor Poll Period (s) (default is 1.0)
#- IO_POLL_PERIOD - Optional: IO Poll period (s) (default is 1.0)
#- IDLE_POLL      - Optional: Idle poll period (s) (default is equal to POLL_PERIOD)
#- MOVING_POLL    - Optional: Moving poll period (s) (default is equal to POLL_PERIOD)


### Traditional approach (substitution files)
#
# Copy the appropriate substitution file for your axis count from
# the substitutions directory (AcsMotion_8, _16, _32, or _64) and
# rename it to match your instance name.

# Use the following line if motorAcsMotion is built as a submodule of motor
iocshLoad("$(MOTOR)/iocsh/ACS_Motion_tcp.iocsh", "INSTANCE=$(INSTANCE), IP_ADDR=$(IP_ADDR), NUM_AXES=$(NUM_AXES=32), MOVING_POLL=$(MOVING_POLL=$(POLL_PERIOD=1.0)), IDLE_POLL=$(IDLE_POLL=$(POLL_PERIOD=1.0))")
iocshLoad("$(MOTOR)/iocsh/ACS_Motion_AuxIO_tcp.iocsh", "INSTANCE=$(INSTANCE)_IO, IP_ADDR=$(IP_ADDR), NUM_CHAN=$(NUM_CHAN=32), POLL_PERIOD=$(IO_POLL_PERIOD=1.0)")

# Select the substitution file matching your axis count:
#dbLoadTemplate("$(SUB=substitutions/$(INSTANCE).substitutions)","P=$(PREFIX)$(INSTANCE):, PORT=$(INSTANCE), R=pm:, NAXES=8")
#dbLoadTemplate("$(SUB=substitutions/$(INSTANCE).substitutions)","P=$(PREFIX)$(INSTANCE):, PORT=$(INSTANCE), R=pm:, NAXES=16")
dbLoadTemplate("$(SUB=substitutions/$(INSTANCE).substitutions)","P=$(PREFIX)$(INSTANCE):, PORT=$(INSTANCE), R=pm:, NAXES=32")
#dbLoadTemplate("$(SUB=substitutions/$(INSTANCE).substitutions)","P=$(PREFIX)$(INSTANCE):, PORT=$(INSTANCE), R=pm:, NAXES=64")

dbLoadTemplate("$(IO_SUB=substitutions/$(INSTANCE)_IO.substitutions)", "P=$(PREFIX), C=$(INSTANCE):, PORT=$(INSTANCE)_IO")


### Alternative: Lua-based approach
#
# Uses a Lua settings file for per-axis configuration instead of large
# substitution files. Only specify per-axis values that differ from defaults.
# Copy scripts/ACS-settings.lua to settings/<name>.lua and edit.
# See scripts/ACS_MP4U.lua for all available parameters and defaults.
#
#luaLoadFile("scripts/ACS_MP4U.lua", "PREFIX=$(PREFIX), INSTANCE=$(INSTANCE), MOTOR_SETTINGS='settings/$(INSTANCE)', IP_ADDR=$(IP_ADDR)")
#iocshLoad("$(MOTOR)/iocsh/ACS_Motion_AuxIO_tcp.iocsh", "INSTANCE=$(INSTANCE)_IO, IP_ADDR=$(IP_ADDR), NUM_CHAN=$(NUM_CHAN=32), POLL_PERIOD=$(IO_POLL_PERIOD=1.0)")
#dbLoadTemplate("$(IO_SUB=substitutions/$(INSTANCE)_IO.substitutions)", "P=$(PREFIX), C=$(INSTANCE):, PORT=$(INSTANCE)_IO")


# Load an asyn record for debugging
dbLoadRecords("$(ASYN)/db/asynRecord.db", "P=$(PREFIX)$(INSTANCE):, R=asyn,   PORT=$(INSTANCE)_ETH, ADDR=0, OMAX=256, IMAX=256")
dbLoadRecords("$(ASYN)/db/asynRecord.db", "P=$(PREFIX)$(INSTANCE):, R=ioasyn, PORT=$(INSTANCE)_IO_ETH, ADDR=0, OMAX=256, IMAX=256")
