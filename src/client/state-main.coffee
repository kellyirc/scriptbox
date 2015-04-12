Map = require '../common/map'
GameObject = require '../common/object'

module.exports = class MainState extends Phaser.State
	preload: ->

	create: ->
		@map = new Map

		@addObject 64, 0, 32, 32, no, 0x0055ff
		@addObject 40, 300, 160, 32, yes, 0xffffff

	addObject: (x, y, width, height, _static = yes, color) ->
		obj = new GameObject @map, {x, y, width, height}
		obj.static = _static

		obj.setYAcceleration 10 if not _static
		obj.setYTargetVelocity 50 if not _static

		@map.objects.push obj

		obj.graphics = @game.add.graphics x, y

		obj.graphics.beginFill color, 1
		obj.graphics.drawRect 0, 0, width, height

		obj

	update: ->
		for obj in @map.objects
			obj.update 0.16

			obj.graphics.x = obj.bounds.left
			obj.graphics.y = obj.bounds.top

		@map.collision()

		null