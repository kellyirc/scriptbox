Map = require '../common/map'
GameObject = require '../common/object'
id = require '../common/id-generation'
NetServer = require './netserver'

module.exports = class Game
	constructor: (@primus) ->
		@maps = []

		@clients = {}

		@tickRate = 1000/10

		@map = new Map
		@map.id = 'hub'
		@maps.push @map
		
		@netserver = new NetServer

		@primus
		.on 'connection', @connection
		.on 'disconnection', @disconnection

		.on 'joinroom', (room, spark) => console.log spark.address, 'joined', room
		.on 'leaveroom', (room, spark) => console.log spark.address, 'left', room

		.on 'error', (err) ->
			console.log err.stack

	connection: (spark) =>
		console.log 'Connection!', spark.address

		object = @addObject @map, 64, 0, 32, 32

		@clients[spark.id] =
			map: @map
			object: object
			spark: spark

		# always make players join hub world first
		spark.join "map:#{@clients[spark.id].map.id}"
		
		spark.on "data", (data) => @netserver.handleData spark, data

	disconnection: (spark) =>
		spark.leave "map:#{@clients[spark.id].map.id}"

		delete @clients[spark.id]

	addObject: (map, x, y, width, height) ->
		obj = new GameObject map, {x, y, width, height}
		obj.id = id.generate()
		obj.static = no

		obj.setYAcceleration 10
		obj.setYTargetVelocity 50

		map.objects.push obj

		obj

	tick: =>
		for map in @maps
			for obj in map.objects
				obj.update 1/@tickRate

			map.collision()

		setTimeout @tick, @tickRate