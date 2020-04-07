local callTo = require(script.Parent.callTo)

return function(fakedTable, key)
	callTo(fakedTable, key)
end
