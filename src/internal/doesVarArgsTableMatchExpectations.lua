local argMatchSymbol = require(script.Parent.Parent.internal.argMatchSymbol)
local isNaN = require(script.Parent.Parent.internal.isNaN)
local wildcard = require(script.Parent.Parent.symbols.wildcard)

return function (actual, expected)
	if actual.length == nil or expected.length == nil then
		error("Invalid var args tables, cannot compare")
	end

	if actual.length ~= expected.length then
		return false
	end

	for i = 1, actual.length do
		local ithActual = actual[i]
		local ithExpected = expected[i]

		local doesActualEqualExpected = ithActual == ithExpected
		if doesActualEqualExpected then
			return true
		end

		local isExpectedSetToWildcard = ithExpected == wildcard
		if isExpectedSetToWildcard then
			return true
		end

		local areBothValuesNaN = isNaN(ithActual) and isNaN(ithExpected)
		if areBothValuesNaN then
			return true
		end

		local isExpectedSetToMatchFunction = type(ithExpected) == "table" and ithExpected[argMatchSymbol] ~= nil
		if isExpectedSetToMatchFunction then
			local doesActualPassMatchingFunction = ithExpected.doesMatch(ithActual)
			return doesActualPassMatchingFunction
		end

		return false
	end

	return true
end
