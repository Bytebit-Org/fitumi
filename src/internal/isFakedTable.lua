local internalsSymbol = require(script.Parent.Parent.internal.internalsSymbol)

return function (arg)
	if arg == nil then
		return false
	end

	if type(arg) ~= "table" then
		return false
	end

	if arg[internalsSymbol] == nil then
		return false
	end

	if type(arg[internalsSymbol]) ~= "table" then
		return false
	end

	return true
end
