NumFunc = require './util/numfunc'

module.exports = class Movement
	constructor: (ang = 0, targetVel = 0, accel, currentVel) ->
		@angle = ang
		cos = Math.cos(@angle)
		sin = Math.sin(@angle)
		@targetVelocity = x: cos*targetVel, y: sin*targetVel
		@acceleration =
			x:if accel then accel*cos else 0
			y:if accel then accel*sin else 0
		@currentVelocity =
			x:currentVel*cos ?= 0
			y:currentVel*sin ?= 0
		unless accel?
			unless currentVel?
				@currentVelocity.x = @targetVelocity.x
				@currentVelocity.y = @targetVelocity.y

	currentAcc: (delta) ->
		xDir = if @currentVelocity.x < @targetVelocity.x then 1 else -1
		yDir = if @currentVelocity.y < @targetVelocity.y then 1 else -1
		x: if @currentVelocity.x is @targetVelocity.x then 0 else @acceleration.x*xDir
		y: if @currentVelocity.y is @targetVelocity.y then 0 else @acceleration.y*yDir
	
	update: (delta) ->
		for i in ["x","y"]
			if @acceleration[i]
				unless @targetVelocity[i] == @currentVelocity[i]
					@currentVelocity[i] = NumFunc.stepTowards(
						@currentVelocity[i], @targetVelocity[i], @acceleration[i]*delta
					)
					
	# For changing the movement while it already exists
	adjust: (ang, targetVel, accel, currentVel) ->
		@angle = ang if ang?
		cos = Math.cos(@angle)
		sin = Math.sin(@angle)
		if targetVel? or ang?
			@targetVelocity.x = cos*targetVel
			@targetVelocity.y = sin*targetVel
		if accel? or ang?
			@acceleration.x = cos*accel
			@acceleration.y = sin*accel
		if currentVel? or ang?
			@currentVelocity.x = cos*targetVel
			@currentVelocity.y = sin*targetVel