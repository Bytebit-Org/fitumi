local valueGeneratorCallbackSymbol = require(script.Parent.Parent.internal.valueGeneratorCallbackSymbol)

return function (callback)
	local valueGeneratorCallbackTable = {
		[valueGeneratorCallbackSymbol] = {}
	}

	valueGeneratorCallbackTable.__call = function(_, ...)
		return callback(...)
	end

	return valueGeneratorCallbackTable
end
