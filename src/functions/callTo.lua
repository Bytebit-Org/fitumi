local internalsSymbol = require(script.Parent.Parent.symbols.internalsSymbol)

function isNaN(val)
	return val ~= val
end

return function (fakedTable, key, ...)
	local expectedArgs = { length = select("#", ...), ... }

	if not fakedTable[key] then
		fakedTable[key] = function(...)
			local givenArgs = { length = select("#", ...), ... }

			local returnsArray = fakedTable[internalsSymbol].functionReturns[key]
			if not returnsArray then
				return nil
			end

			local returnValueGetter = nil

			for i = 1, returnsArray.length do
				local returnInfo = returnsArray[i]
				if returnInfo.args.length == givenArgs.length then
					local doesMatch = true

					for j = 1, givenArgs.length do
						local doesJthArgMatch = givenArgs[j] == returnInfo.args[j] or
							(isNaN(givenArgs[j]) and isNaN(returnInfo.args[j]))
						if not doesJthArgMatch then
							doesMatch = false
							break
						end
					end

					if doesMatch then
						returnValueGetter = returnInfo.valueGetter
						break
					end
				end
			end

			if returnValueGetter then
				return returnValueGetter()
			else
				return nil
			end
		end
	end

	return {
		returns = function(self, ...)
			if not fakedTable[internalsSymbol].functionReturns[key] then
				fakedTable[internalsSymbol].functionReturns[key] = {}
			end

			local returnVals = { ... }

			table.insert(fakedTable[internalsSymbol].functionReturns[key], {
				args = expectedArgs,
				valueGetter = function()
					return table.unpack(returnVals)
				end
			})
		end
	}
end
