local fakedMetaTable = {}

return function ()
	return setmetatable({
		_functionReturns = {}
	}, fakedMetaTable)
end
