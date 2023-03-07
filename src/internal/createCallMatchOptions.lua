local createCallBehaviorOptions = require(script.Parent.createCallBehaviorOptions)
local doesVarArgsTableMatchExpectations = require(script.Parent.doesVarArgsTableMatchExpectations)
local internalsSymbol = require(script.Parent.internalsSymbol)
local isFakedTable = require(script.Parent.isFakedTable)
local valueGeneratorCallbackSymbol = require(script.Parent.valueGeneratorCallbackSymbol)

return function (fakedTable, expectedArgs)
	assert(isFakedTable(fakedTable), "Can only use createCallResult on a faked table")

	return {
		-- behavior options
		executes = function (self, callback)
			local callBehavior = {
				args = expectedArgs,
				invoke = callback
			}
			table.insert(fakedTable[internalsSymbol].callBehaviors, 1, callBehavior)

			return createCallBehaviorOptions(self, callBehavior)
		end,
		throws = function (self, errorArgs)
			local callBehavior = {
				args = expectedArgs,
				throw = function ()
					error(errorArgs)
				end
			}

			table.insert(fakedTable[internalsSymbol].callBehaviors, 1, callBehavior)

			return createCallBehaviorOptions(self, callBehavior)
		end,
		returns = function(self, ...)
			local n = select("#", ...)
			local returnVals = { ... }

			local callBehavior = {
				args = expectedArgs,
				returnValueGetter = function()
					if n == 1 and type(returnVals[1]) == "table" and type(returnVals[1][valueGeneratorCallbackSymbol]) == "function" then
						return returnVals[1]()
					end

					return unpack(returnVals)
				end
			}

			table.insert(fakedTable[internalsSymbol].callBehaviors, 1, callBehavior)

			return createCallBehaviorOptions(self, callBehavior)
		end,

		-- invokes checks
		didHappen = function()
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
		end
	}
end
