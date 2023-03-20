local argMatchSymbol = require(script.Parent.Parent.internal.argMatchSymbol)

return function (doesMatch)
	return {
		[argMatchSymbol] = true,

		doesMatch = doesMatch
	}
end
