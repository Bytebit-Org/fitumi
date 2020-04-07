local internalsSymbol = require(script.Parent.Parent.internal.internalsSymbol)

return function (fakedTable)
	fakedTable[internalsSymbol].callHistory = {}
end
