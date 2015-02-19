NumFunc = require './util/numfunc'

module.exports = class Movement
	constructor: (ang = 0, targetvel = 0, accel, currentvel) ->
		@angle = ang
		cos = Math.cos(@angle)
		sin = Math.sin(@angle)
		@targetvelocity = x: cos*targetvel, y: sin*targetvel
		@acceleration =
			x:if accel then accel*cos else 0
			y:if accel then accel*sin else 0
		@currentvelocity =
			x:currentvel*cos ?= 0
			y:currentvel*sin ?= 0
		unless accel?
			unless currentvel?
				@currentvelocity.x = @targetvelocity.x
				@currentvelocity.y = @targetvelocity.y

	currentAcc: (delta) ->
		xdir = if @currentvelocity.x < @targetvelocity.x then 1 else -1
		ydir = if @currentvelocity.y < @targetvelocity.y then 1 else -1
		x: if @currentvelocity.x is @targetvelocity.x then 0 else @acceleration*xdir
		y: if @currentvelocity.y is @targetvelocity.y then 0 else @acceleration*ydir
	
	update: (delta) ->
		for i in ["x","y"]
			if @acceleration[i]
				unless @targetvelocity[i] == @currentvelocity[i]
					NumFunc.stepTowards(
						@currentvelocity[i], @targetvelocity[i], @acceleration[i]*delta
					)
					
	# For changing the movement while it already exists
	adjust: (ang, targetvel, accel, currentvel) ->
		@angle = ang if ang?
		cos = Math.cos(@angle)
		sin = Math.sin(@angle)
		if targetvel? or ang?
			@targetvelocity.x = cos*targetvel
			@targetvelocity.y = sin*targetvel
		if accel? or ang?
			@acceleration.x = cos*accel
			@acceleration.y = sin*accel
		if currentvel? or ang?
			@currentvelocity.x = cos*targetvel
			@currentvelocity.y = sin*targetvel