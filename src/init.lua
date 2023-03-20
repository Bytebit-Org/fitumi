return {
	a = require(script.a),
	clearCallHistory = require(script.functions.clearCallHistory),
	clearWriteHistory = require(script.functions.clearWriteHistory),
	ignore = function () return require(script.symbols.wildcard) end,
	isFake = require(script.functions.isFake),
	wildcard = require(script.symbols.wildcard)
}
