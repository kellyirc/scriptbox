module.exports = class Rect
	constructor: (obj) ->
		@x = 0
		@y = 0

		@width = 0
		@height = 0

		Object.defineProperties @,
			left:
				set: (v) => @x = v
				get: => @x
			top:
				set: (v) => @y = v
				get: => @y

			right:
				set: (v) => @width = v - @x
				get: => @y + @width
			bottom:
				set: (v) => @height = v - @y
				get: => @x + @height

		switch
			when obj.x? and obj.y? and obj.width? and obj.height?
				{@x, @y, @width, @height} = obj

			when obj.left? and obj.top? and obj.bottom? and obj.right?
				{@left, @top, @bottom, @right} = obj

			when obj.topLeft? and obj.bottomRight?
				{topLeft, bottomRight} = obj
				{@x, @y} = topLeft
				{x: @bottom, y: @right} = bottomRight

	overlaps: (rect) ->
		not (
			@left > rect.right or
			@right < rect.left or
			@top > rect.bottom or
			@bottom < rect.top
		)