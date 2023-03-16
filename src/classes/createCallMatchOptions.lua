local cloneSymbol = require(script.Parent.Parent.internal.cloneSymbol)
local createCallBehaviorOptions = require(script.Parent.createCallBehaviorOptions)
local createCallResultOptions = require(script.Parent.createCallResultOptions)
local doesVarArgsTableMatchExpectations = require(script.Parent.Parent.internal.doesVarArgsTableMatchExpectations)
local internalsSymbol = require(script.Parent.Parent.internal.internalsSymbol)
local isFakedTable = require(script.Parent.Parent.internal.isFakedTable)
local valueGeneratorCallbackSymbol = require(script.Parent.Parent.internal.valueGeneratorCallbackSymbol)

function createCallMatchOptions(fakedTable, expectedArgs, higherPrecedenceBehavior, higherPrecedenceResult)
	assert(isFakedTable(fakedTable), "Can only use createCallResult on a faked table")

	function addCallBehaviorToFakedTable(callBehavior)
		local insertIndex = 1

		if higherPrecedenceBehavior then
			for i = 1, #fakedTable[internalsSymbol].callBehaviors do
				if fakedTable[internalsSymbol].callBehaviors[i] == higherPrecedenceBehavior then
					insertIndex = i + 1
					break
				end
			end
		end

		table.insert(fakedTable[internalsSymbol].callBehaviors, insertIndex, callBehavior)
	end

	function addCallResultToFakedTable(callResult)
		local insertIndex = 1

		if higherPrecedenceResult then
			for i = 1, #fakedTable[internalsSymbol].callResults do
				if fakedTable[internalsSymbol].callResults[i] == higherPrecedenceResult then
					insertIndex = i + 1
					break
				end
			end
		end

		table.insert(fakedTable[internalsSymbol].callResults, insertIndex, callResult)
	end

	return {
		[cloneSymbol] = function (newHigherPrecedenceBehavior, newHigherPrecedenceResult)
			return createCallMatchOptions(fakedTable, expectedArgs, newHigherPrecedenceBehavior, newHigherPrecedenceResult)
		end,

		-- behavior options
		executes = function (self, callback)
			local callBehavior = {
				args = expectedArgs,
				invoke = callback
			}

			addCallBehaviorToFakedTable(callBehavior)

			return createCallBehaviorOptions(self, callBehavior, higherPrecedenceResult)
		end,

		-- result options
		throws = function (self, errorArgs)
			local callResult = {
				args = expectedArgs,
				throw = function ()
					error(errorArgs)
				end
			}

			addCallResultToFakedTable(callResult)

			return createCallResultOptions(self, higherPrecedenceBehavior, callResult)
		end,
		returns = function(self, ...)
			local n = select("#", ...)
			local returnVals = { ... }

			local callResult = {
				args = expectedArgs,
				returnValueGetter = function()
					if n == 1 and type(returnVals[1]) == "table" and type(returnVals[1][valueGeneratorCallbackSymbol]) == "function" then
						return returnVals[1]()
					end

					return unpack(returnVals)
				end
			}

			addCallResultToFakedTable(callResult)

			return createCallResultOptions(self, higherPrecedenceBehavior, callResult)
		end,

		-- invokes checks
		countNumberOfMatchingCalls = function()
			local invokeCount = 0

			local callHistory = fakedTable[internalsSymbol].callHistory
			for i = 1, #callHistory do
				if doesVarArgsTableMatchExpectations(callHistory[i], expectedArgs) then
					invokeCount = invokeCount + 1
				end
			end

			return invokeCount
		end,
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
		end,
	}
end

return createCallMatchOptions
