local internalsSymbol = require(script.Parent.Parent.symbols.internalsSymbol)

local fakedFieldMetaTable;

local function fakedTableCall()
	return nil
end

local function fakedTableIndex()
	return setmetatable({}, fakedFieldMetaTable)
end

local fakedMetaTable = {
	__index = fakedTableIndex
}

fakedFieldMetaTable = {
	__call = fakedTableCall,
	__index = fakedTableIndex
}

return function ()
	return setmetatable({
		[internalsSymbol] = {
			functionReturns = {}
		}
	}, fakedMetaTable)
end
