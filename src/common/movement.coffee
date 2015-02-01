NumFunc = require './util/numfunc'

module.exports = class Movement
	constructor: (ident, ang = 0, targetvel = 0, accel, currentvel) ->
		@identifier
		@angle = ang
		cos = Math.cos(@angle)
		sin = Math.sin(@angle)
		@targetvelocity = x: cos*targetvel, y: sin*targetvel
		@acceleration = x: cos*accel, y: sin*accel if accel
		@currentvelocity = x: cos*currentvel, y: sin*currentvel if currentvel
		unless currentvel?
			for i in [x,y]
				@currentvelocity.i = @targetvelocity.i unless @accel?

	update: (delta) ->
		for i in [x,y]
			if @acceleration.i
				unless @targetvelocity.i == @currentvelocity.i
					NumFunc.stepTowards(@currentvelocity.i, @targetvelocity.i, @acceleration.i)
					
	# For changing the movement while it already exists

	adjust: (ang, targetvel, accel, currentvel) ->
		@angle = ang if ang?
		cos = Math.cos(@angle)
		sin = Math.sin(@angle)
		if targetvel? or ang?
			targetvelocity.x = cos*targetvel
			targetvelocity.y = sin*targetvel
		if accel? or ang?
			acceleration.x = cos*accel
			acceleration.y = sin*accel
		if currentvel? or ang?
			currentvelocity.x = cos*targetvel
			currentvelocity.y = sin*targetvel