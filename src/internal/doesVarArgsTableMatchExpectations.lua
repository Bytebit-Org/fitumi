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
			continue
		end

		local isExpectedSetToWildcard = ithExpected == wildcard
		if isExpectedSetToWildcard then
			continue
		end

		local areBothValuesNaN = isNaN(ithExpected) and isNaN(ithActual)
		if areBothValuesNaN then
			continue
		end

		local isExpectedSetToMatchingFunction = type(ithExpected) == "table" and ithExpected[argMatchSymbol] ~= nil
		if isExpectedSetToMatchingFunction then
			local doesActualPassMatchingFunction = ithExpected.doesMatch(ithActual)
			if doesActualPassMatchingFunction then
				continue
			end
		end

		-- Nothing worked for this argument? Tables don't match.
		return false
	end

	return true
end
