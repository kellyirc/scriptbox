module.exports = class Map
	constructor: ->
		@objects = []

	add: (object) ->

	remove: (object) ->

	updatePosition: (object) ->
		# do nothing ATM

	collision: ->
		for obj1, i in @objects
			for j in [i+1...@objects.length]
				obj2 = @objects[j]

				@handleCollision obj1, obj2

		return

	handleCollision: (obj1, obj2) ->
		if obj1.bounds.overlaps obj2.bounds
			# determine factor of displacement for objects
			df1 = 0.5
			df1 = 0 if obj1.static
			df1 = 1 if obj2.static

			df2 = if obj1.static and obj2.static then 0 else 1 - df1

			# separate on X axis
			xOverlap = 0

			o1 = obj1.bounds.right - obj2.bounds.left
			o2 = obj1.bounds.left - obj2.bounds.right

			xOverlap = if (Math.abs o1) < (Math.abs o2) then o1 else o2

			obj1.x -= xOverlap * df1
			obj2.x += xOverlap * df2

			# separate on Y axis
			yOverlap = 0

			o1 = obj1.bounds.bottom - obj2.bounds.top
			o2 = obj1.bounds.top - obj2.bounds.bottom

			yOverlap = if (Math.abs o1) < (Math.abs o2) then o1 else o2

			obj1.y -= yOverlap * df1
			obj2.y += yOverlap * df2

		return