local callTo = require(script.Parent.callTo)

return function (fakedObject, key, ...)
	return callTo(fakedObject[key], fakedObject, ...)
end
