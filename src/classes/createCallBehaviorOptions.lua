return function (callResult, callBehavior)
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

		andThen = callResult,
	})
end
