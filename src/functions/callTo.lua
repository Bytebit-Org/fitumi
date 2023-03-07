local createCallMatchOptions = require(script.Parent.Parent.classes.createCallMatchOptions)
local isFakedTable = require(script.Parent.Parent.internal.isFakedTable)
local varArgsToTable = require(script.Parent.Parent.internal.varArgsToTable)

return function (fakedTable, ...)
	assert(isFakedTable(fakedTable), "Can only use callTo on a faked table")

	local expectedArgs = varArgsToTable(...)

	return createCallMatchOptions(fakedTable, expectedArgs)
end
