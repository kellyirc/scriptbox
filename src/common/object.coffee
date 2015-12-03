Rect = require './util/rect'
_ = require 'lodash'
Movement = require './movement'

module.exports = class GameObject
	constructor: (@map, {@x, @y, @width, @height}) ->
		@bounds = new Rect {
			x: @x - @width/2
			y: @y - @height/2
			@width, @height
		}

		Object.defineProperties @,
			x:
				get: => @bounds.centerX
				set: (v) => @bounds.centerX = v

			y:
				get: => @bounds.centerY
				set: (v) => @bounds.centerY = v

		@velocity = x: 0, y: 0
		@acceleration = x: 0, y: 0
		@movements = {default:new Movement}
		@static = no

	move: (x, y) ->
		@x = x
		@y = y

		@map.updatePosition @

	update: (delta) ->
		@velocity.x = _.reduce @movements, (p, c) ->
			p + c.currentVelocity.x
		, 0
		@velocity.y = _.reduce @movements, (p, c) ->
			p + c.currentVelocity.y
		, 0
		@acceleration.x = _.reduce @movements, (p, c) ->
			p + c.currentAcc(delta).x
		, 0
		@acceleration.y = _.reduce @movements, (p, c) ->
			p + c.currentAcc(delta).y
		, 0
			
		@move(
			@x + @velocity.x * delta + (@acceleration.x * delta * delta) / 2
			@y + @velocity.y * delta + (@acceleration.y * delta * delta) / 2
		)
		
		_.each @movements, (o) -> o.update(delta)
		
	addMovement: (name = "default", ang, targetVel, accel, currentVel) ->
		if @movements[name]
			@movements[name].adjust ang, targetVel, accel, currentVel
		else
			@movements[name] = new Movement ang, targetVel, accel, currentVel
			
	removeMovement: (name) ->
		delete @movements[name]
			
	setVelocity: (vel = 0, ang = 0) ->
		@movements["default"].currentVelocity.x = cos(ang)*vel
		@movements["default"].currentVelocity.y = sin(ang)*vel
	
	setXVelocity: (vel = 0) ->
		@movements["default"].currentVelocity.x = vel

	setYVelocity: (vel = 0) ->
		@movements["default"].currentVelocity.y = vel
		
	setTargetVelocity: (vel = 0, ang = 0) ->
		@movements["default"].targetVelocity.x = cos(ang)*vel
		@movements["default"].targetVelocity.y = sin(ang)*vel
		
	setXTargetVelocity: (vel = 0) ->
		@movements["default"].targetVelocity.x = vel

	setYTargetVelocity: (vel = 0) ->
		@movements["default"].targetVelocity.y = vel
		
	setAcceleration: (acc = 0, ang = 0) ->
		@movements["default"].acceleration.x = cos(ang)*acc
		
	setXAcceleration: (acc = 0) ->
		@movements["default"].acceleration.x = acc

	setYAcceleration: (acc = 0) ->
		@movements["default"].acceleration.y = acc
		
	toJSON: ->
		_.omit this, 'map'
		
		