local doesVarArgsTableMatchExpectations = require(script.Parent.Parent.internal.doesVarArgsTableMatchExpectations)
local internalsSymbol = require(script.Parent.Parent.internal.internalsSymbol)
local nilSymbol = require(script.Parent.Parent.internal.nilSymbol)
local varArgsToTable = require(script.Parent.Parent.internal.varArgsToTable)

local fakedMetaTable;

local function createFake()
	return setmetatable({
		[internalsSymbol] = {
			callHistory = {},
			callErrors = {},
			executionCallbacks = {},
			functionReturns = {},
			setValues = {},
			writeHistory = {}
		}
	}, fakedMetaTable)
end

local function fakedTableCall(fakedTable, ...)
	local givenArgs = varArgsToTable(...)

	table.insert(fakedTable[internalsSymbol].callHistory, givenArgs)

	local executionCallbacks = fakedTable[internalsSymbol].executionCallbacks
	if executionCallbacks then
		for i = 1, #executionCallbacks do
			local executionCallbackInfo = executionCallbacks[i]
			if doesVarArgsTableMatchExpectations(givenArgs, executionCallbackInfo.args) then
				executionCallbackInfo.invoke(unpack(givenArgs))
			end
		end
	end

	local callErrors = fakedTable[internalsSymbol].callErrors
	if callErrors then
		for i = 1, #callErrors do
			local callErrorInfo = callErrors[i]
			if doesVarArgsTableMatchExpectations(givenArgs, callErrorInfo.args) then
				callErrorInfo.throw()
			end
		end
	end

	local functionReturns = fakedTable[internalsSymbol].functionReturns
	if not functionReturns then
		return nil
	end

	local returnValueGetter = nil

	for i = 1, #functionReturns do
		local returnInfo = functionReturns[i]
		if doesVarArgsTableMatchExpectations(givenArgs, returnInfo.args) then
			returnValueGetter = returnInfo.valueGetter
			break
		end
	end

	if returnValueGetter then
		return returnValueGetter()
	else
		return nil
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
