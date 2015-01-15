Map = require '../common/map'
GameObject = require '../common/object'
id = require '../common/id-generation'

module.exports = class Game
	constructor: (@primus) ->
		@maps = []

		@clients = {}

		@tickRate = 1000/10

		@map = new Map
		@maps.push @map

		@primus
		.on 'connection', @connection
		.on 'disconnection', @disconnection

	connection: (spark) =>
		console.log 'Connection!', spark.address

		@addObject @map, 64, 0, 32, 32

	disconnection: (spark) =>

	addObject: (map, x, y, width, height) ->
		obj = new GameObject map, {x, y, width, height}
		obj.id = id.generate()
		obj.static = no

		obj.acceleration.y = 10

		map.objects.push obj

		obj

	tick: =>
		for map in @maps
			for obj in map.objects
				obj.update 1/@tickRate

			map.collision()

		setTimeout @tick, @tickRate