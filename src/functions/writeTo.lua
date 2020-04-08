local internalsSymbol = require(script.Parent.Parent.internal.internalsSymbol)
local isFakedTable = require(script.Parent.Parent.internal.isFakedTable)
local isNaN = require(script.Parent.Parent.internal.isNaN)
local wildcard = require(script.Parent.Parent.symbols.wildcard)

return function (fakedTable, key, expectedValue)
	assert(isFakedTable(fakedTable), "Can only use writeTo on a faked table")

	local isExpectedValueNaN = isNaN(expectedValue)
	local isExpectedValueWildcard = expectedValue == wildcard

	return {
		didHappen = function(self)
			local writeHistoryForKey = fakedTable[internalsSymbol].writeHistory[key]
			if writeHistoryForKey == nil then
				return false
			end

			local writeHistoryLengthForKey = #writeHistoryForKey

			if writeHistoryLengthForKey > 0 and isExpectedValueWildcard then
				return true
			end

			for i = 1, writeHistoryLengthForKey do
				if isExpectedValueNaN and isNaN(writeHistoryForKey[i]) then
					return true
				end

				if writeHistoryForKey[i] == expectedValue then
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
