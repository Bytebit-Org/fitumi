local cloneSymbol = require(script.Parent.Parent.internal.cloneSymbol)

return function (callMatchOptions, higherPrecedenceBehavior, callResult)
	callResult.numberOfRemainingUses = -1

	return table.freeze({
		once = function (self)
			callResult.numberOfRemainingUses = 1
			return self
		end,

		twice = function (self)
			callResult.numberOfRemainingUses = 2
			return self
		end,

		numberOfTimes = function (self, numberOfTimes)
			callResult.numberOfRemainingUses = numberOfTimes
			return self
		end,

		andThen = callMatchOptions[cloneSymbol](higherPrecedenceBehavior, callResult),
	})
end
