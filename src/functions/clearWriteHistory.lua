local internalsSymbol = require(script.Parent.Parent.internal.internalsSymbol)
local isFakedTable = require(script.Parent.Parent.internal.isFakedTable)

return function (fakedTable, key)
	assert(isFakedTable(fakedTable), "Can only clear write history on a faked table")

	if key == nil then
		fakedTable[internalsSymbol].writeHistory = {}
	else
		fakedTable[internalsSymbol].writeHistory[key] = nil
	end
end
