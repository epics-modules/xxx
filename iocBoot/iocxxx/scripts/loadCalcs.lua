-- NUM_SETS - Number of sets of 10 to load
-- ARRAY_SIZE - arrayCalc array size

dbLoadRecords("$(CALC)/db/userCalcGlobalEnable.db", "P=$(PREFIX)")

for index = 1, NUM_SETS do
	local N = 10 * (index - 1)
	local macros = string.format("P=$(PREFIX),N1=%d,N2=%d,N3=%d,N4=%d,N5=%d,N6=%d,N7=%d,N8=%d,N9=%d,N10=%d", N+1, N+2, N+3, N+4, N+5, N+6, N+7, N+8, N+9, N+10)

	local size = ARRAY_SIZE
	if size == nil then size = 8000 end
	
	dbLoadRecords("$(CALC)/db/userCalcs10more.db", macros)
	dbLoadRecords("$(CALC)/db/userCalcOuts10more.db", macros)
	dbLoadRecords("$(CALC)/db/userStringCalcs10more.db", macros)
	dbLoadRecords("$(CALC)/db/userArrayCalcs10more.db", macros .. string.format(",N=%d", size))
	dbLoadRecords("$(CALC)/db/userTransforms10more.db", macros)
	dbLoadRecords("$(CALC)/db/userAve10more.db", macros)
end
