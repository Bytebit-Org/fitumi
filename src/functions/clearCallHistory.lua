local internalsSymbol = require(script.Parent.Parent.internal.internalsSymbol)
local isFakedTable = require(script.Parent.Parent.internal.isFakedTable)

return function (fakedTable)
	assert(isFakedTable(fakedTable), "Can only clear call history on a faked table")

	fakedTable[internalsSymbol].callHistory = {}
end
