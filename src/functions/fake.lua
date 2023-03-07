local doesVarArgsTableMatchExpectations = require(script.Parent.Parent.internal.doesVarArgsTableMatchExpectations)
local internalsSymbol = require(script.Parent.Parent.internal.internalsSymbol)
local nilSymbol = require(script.Parent.Parent.internal.nilSymbol)
local varArgsToTable = require(script.Parent.Parent.internal.varArgsToTable)

local fakedMetaTable;

local function createFake()
	return setmetatable({
		[internalsSymbol] = {
			callBehaviors = {},
			callHistory = {},
			setValues = {},
			writeHistory = {}
		}
	}, fakedMetaTable)
end

local function fakedTableCall(fakedTable, ...)
	local givenArgs = varArgsToTable(...)

	table.insert(fakedTable[internalsSymbol].callHistory, givenArgs)

	local callBehaviors = fakedTable[internalsSymbol].callBehaviors
	if not callBehaviors then
		return
	end

	for i = 1, #callBehaviors do
		local callBehavior = callBehaviors[i]
		if doesVarArgsTableMatchExpectations(givenArgs, callBehavior.args) then
			callBehavior.numberOfRemainingUses = callBehavior.numberOfRemainingUses - 1
			if callBehavior.numberOfRemainingUses == 0 then
				table.remove(callBehaviors, i)
			end

			if callBehavior["invoke"] then
				-- callTo(...):executes(...)
				callBehavior.invoke(unpack(givenArgs))
			elseif callBehavior["throw"] then
				-- callTo(...):throws(...)
				callBehavior.throw()
			elseif callBehavior["returnValueGetter"] then
				-- callTo(...):returns(...)
				return callBehavior.returnValueGetter()
			end

			break
		end
	end
end

local function fakedTableIndex(tbl, key)
	if tbl[internalsSymbol].setValues[key] == nil then
		tbl[internalsSymbol].setValues[key] = createFake()
	end

	if tbl[internalsSymbol].setValues[key] == nilSymbol then
		return nil
	else
		return tbl[internalsSymbol].setValues[key]
	end
end

local function fakedTableNewIndex(tbl, key, value)
	if value == nil then
		value = nilSymbol
	end

	if tbl[internalsSymbol].writeHistory[key] == nil then
		tbl[internalsSymbol].writeHistory[key] = {}
	end
	table.insert(tbl[internalsSymbol].writeHistory[key], value)

	tbl[internalsSymbol].setValues[key] = value
end

fakedMetaTable = {
	__call = fakedTableCall,
	__index = fakedTableIndex,
	__newindex = fakedTableNewIndex
}

return createFake
