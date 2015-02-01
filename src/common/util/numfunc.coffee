exports.stepTowards = (initial, target, step) ->
	return target if Math.abs(target-initial) < step
	return initial - step if initial > target
	return initial + step if initial < target