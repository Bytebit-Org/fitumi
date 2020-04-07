local internalsSymbol = require(script.Parent.Parent.symbols.internalsSymbol)
local nilSymbol = require(script.Parent.Parent.symbols.nilSymbol)

local fakedMetaTable;

local function createFake()
	return setmetatable({
		[internalsSymbol] = {
			functionReturns = {},
			setValues = {}
		}
	}, fakedMetaTable)
end

local function fakedTableCall()
	return nil
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

	tbl[internalsSymbol].setValues[key] = value
end

fakedMetaTable = {
	__call = fakedTableCall,
	__index = fakedTableIndex,
	__newindex = fakedTableNewIndex
}

return createFake
