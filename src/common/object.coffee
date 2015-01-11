Rect = require './util/rect'

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

		@static = no

	move: (x, y) ->
		@x = x
		@y = y

		@map.updatePosition @

	update: (delta) ->
		@move(
			@x + @velocity.x * delta + (@acceleration.x * delta * delta) / 2
			@y + @velocity.y * delta + (@acceleration.y * delta * delta) / 2
		)

		@velocity.x += @acceleration.x * delta
		@velocity.y += @acceleration.y * delta