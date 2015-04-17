module.exports = class Map
	constructor: ->
		@objects = []

	add: (object) ->

	remove: (object) ->

	updatePosition: (object) ->
		# do nothing ATM

	collision: ->
		for obj in @objects
			(obj.collided = {top: no, bottom: no, left: no, right: no})

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

			# calculate X overlap
			xOverlap = 0

			o1 = obj1.bounds.right - obj2.bounds.left
			o2 = obj1.bounds.left - obj2.bounds.right

			xOverlap = if (Math.abs o1) < (Math.abs o2) then o1 else o2

			# calculate Y overlap
			yOverlap = 0

			o1 = obj1.bounds.bottom - obj2.bounds.top
			o2 = obj1.bounds.top - obj2.bounds.bottom

			yOverlap = if (Math.abs o1) < (Math.abs o2) then o1 else o2

			# separate on axis with smallest overlap
			if (Math.abs xOverlap) < (Math.abs yOverlap)
				obj1.x -= xOverlap * df1
				obj2.x += xOverlap * df2

				obj1.velocity.x = obj2.velocity.x = 0

				for name,movement of obj1.movements
					movement.currentVelocity.x = 0

				for name,movement of obj2.movements
					movement.currentVelocity.x = 0

				if xOverlap > 0
					# obj1 colliding on right, obj2 colliding on left
					obj1.collided.right = yes
					obj2.collided.left = yes

				else
					# obj2 colliding on left, obj1 colliding on right
					obj1.collided.left = yes
					obj2.collided.right = yes

			else
				obj1.y -= yOverlap * df1
				obj2.y += yOverlap * df2

				obj1.velocity.y = obj2.velocity.y = 0

				for name,movement of obj1.movements
					movement.currentVelocity.y = 0

				for name,movement of obj2.movements
					movement.currentVelocity.y = 0

				if yOverlap > 0
					# obj1 colliding on bottom, obj2 colliding on top
					obj1.collided.bottom = yes
					obj2.collided.top = yes

				else
					# obj2 colliding on bottom, obj1 colliding on top
					obj1.collided.top = yes
					obj2.collided.bottom = yes

		return