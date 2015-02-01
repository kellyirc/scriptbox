NumFunc = require './util/numfunc'

module.exports = class Velocity
	constructor (ident, ang = 0, targetvel = 0, accel, currentvel): ->
		@identifier
		@angle = ang
		@targetvelocity = x: Math.cos(angle)*targetvel, y: Math.sin(angle)*targetvel
		@acceleration = x: Math.cos(angle)*accel, y: Math.sin(angle)*accel if accel
		@currentvelocity = x: Math.cos(angle)*currentvel, y: Math.sin(angle)*currentvel if currentvel
		unless currentvel?
			for i in [x,y]
				@currentvelocity.i = @targetvelocity.i unless @accel?
			
	update: (delta) ->
		for i in [x,y]
			NumFunc.stepTowards(@currentvelocity.i, @targetvelocity.i, @acceleration.i) if @acceleration.i unless @targetvelocity.i == @currentvelocity.i
			
	# For changing the velocity while it already exists
	adjust: (ang, targetvel, accel, currentvel): ->
		@angle = ang if ang?
		if targetvel? or ang?
			targetvelocity.x = Math.cos(angle)*targetvel
			targetvelocity.y = Math.sin(angle)*targetvel
		if accel? or ang?
			acceleration.x = Math.cos(angle)*accel
			acceleration.y = Math.sin(angle)*accel
		if currentvel? or ang?
			currentvelocity.x = Math.cos(angle)*targetvel
			currentvelocity.y = Math.sin(angle)*targetvel