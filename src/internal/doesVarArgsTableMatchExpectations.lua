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
		local doesJthArgMatch = expected[i] == wildcard or
			actual[i] == expected[i] or
			(isNaN(actual[i]) and isNaN(expected[i]))

		if not doesJthArgMatch then
			return false
		end
	end

	return true
end
