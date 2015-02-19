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
			p + c.currentvelocity.x
		, 0
		@velocity.y = _.reduce @movements, (p, c) ->
			p + c.currentvelocity.y
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
		
		console.log @velocity.x
		
		_.each @movements, (o) -> o.update(delta)
		
	addMovement: (name = "default", ang = 0, targetvel = 0, accel, currentvel) ->
		if @movements[name]
			@movements[name].adjust ang, targetvel, accel, currentvel
		else
			@movements[name] = new Movement ang, targetvel, accel, currentvel
		
		