exports.level = (exp) ->
	1 + Math.floor Math.pow exp/100, 1/1.6
	
exports.expForLevel = (level) ->
	10 * Math.pow (level-1), 1.6
	
exports.toNext = (exp) ->
	@expForLevel(@level(exp) + 1) - exp
	