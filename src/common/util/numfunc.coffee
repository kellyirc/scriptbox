exports.stepTowards = (initial, target, step) ->
	if Math.abs(target-initial) < step
		return target
	if initial > target
		return initial - step
	if initial < target
		return initial + step