local cloneSymbol = require(script.Parent.Parent.internal.cloneSymbol)

return function (callMatchOptions, callBehavior, higherPrecedenceResult)
	callBehavior.numberOfRemainingUses = -1

	return table.freeze({
		once = function (self)
			callBehavior.numberOfRemainingUses = 1
			return self
		end,

		twice = function (self)
			callBehavior.numberOfRemainingUses = 2
			return self
		end,

		numberOfTimes = function (self, numberOfTimes)
			callBehavior.numberOfRemainingUses = numberOfTimes
			return self
		end,

		andThen = callMatchOptions[cloneSymbol](callBehavior, higherPrecedenceResult),
	})
end
