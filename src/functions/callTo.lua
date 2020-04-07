local doesVarArgsTableMatchExpectations = require(script.Parent.Parent.internal.doesVarArgsTableMatchExpectations)
local internalsSymbol = require(script.Parent.Parent.internal.internalsSymbol)
local varArgsToTable = require(script.Parent.Parent.internal.varArgsToTable)

return function (fakedTable, ...)
	local expectedArgs = varArgsToTable(...)

	return {
		didHappen = function(self)
			local callHistory = fakedTable[internalsSymbol].callHistory
			for i = 1, #callHistory do
				if doesVarArgsTableMatchExpectations(callHistory[i], expectedArgs) then
					return true
				end
			end

			return false
		end,
		didNotHappen = function(self)
			return not self:didHappen()
		end,
		returns = function(self, ...)
			local returnVals = { ... }

			table.insert(fakedTable[internalsSymbol].functionReturns, {
				args = expectedArgs,
				valueGetter = function()
					return unpack(returnVals)
				end
			})
		end
	}
end
