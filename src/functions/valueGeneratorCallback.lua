local valueGeneratorCallbackSymbol = require(script.Parent.Parent.internal.valueGeneratorCallbackSymbol)

local valueGeneratorCallbackMetatable = {}
valueGeneratorCallbackMetatable.__call = function(tbl, ...)
	return tbl[valueGeneratorCallbackSymbol](...)
end

return function (callback)
	return setmetatable({
		[valueGeneratorCallbackSymbol] = callback
	}, valueGeneratorCallbackMetatable)
end
