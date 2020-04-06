local internalsSymbol = require(script.Parent.Parent.symbols.internalsSymbol)
local wildcard = require(script.Parent.Parent.symbols.wildcard)

function isNaN(val)
	return val ~= val
end

function varArgsToTable(...)
	return { length = select("#", ...), ... }
end

function doesVarArgsTableMatchExpectations(actual, expected)
	if actual.length ~= expected.length then
		return false
	end

	for i = 1, actual.length do
		local doesJthArgMatch = expected[i] == wildcard or
			actual[i] == expected[i] or
			(isNaN(actual[i]) and isNaN(expected[i]))

		if not doesJthArgMatch then
			return false
		end
	end

	return true
end

return function (fakedTable, key, ...)
	local expectedArgs = varArgsToTable(...)

	if not rawget(fakedTable, key) then
		rawset(fakedTable, key, setmetatable({
			[internalsSymbol] = {
				callHistory = {}
			}
		}, {
			__call = function(tbl, ...)
				local givenArgs = varArgsToTable(...)

				table.insert(tbl[internalsSymbol].callHistory, givenArgs)

				local returnsArray = fakedTable[internalsSymbol].functionReturns[key]
				if not returnsArray then
					return nil
				end

				local returnValueGetter = nil

				for i = 1, #returnsArray do
					local returnInfo = returnsArray[i]
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
		}))
	end

	return {
		didHappen = function(self)
			local callHistory = fakedTable[key][internalsSymbol].callHistory
			for i = 1, #callHistory do
				if doesVarArgsTableMatchExpectations(expectedArgs, callHistory[i]) then
					return true
				end
			end

			return false
		end,
		didNotHappen = function(self)
			return not self:didHappen()
		end,
		returns = function(self, ...)
			if not fakedTable[internalsSymbol].functionReturns[key] then
				fakedTable[internalsSymbol].functionReturns[key] = {}
			end

			local returnVals = { ... }

			table.insert(fakedTable[internalsSymbol].functionReturns[key], {
				args = expectedArgs,
				valueGetter = function()
					return unpack(returnVals)
				end
			})
		end
	}
end
