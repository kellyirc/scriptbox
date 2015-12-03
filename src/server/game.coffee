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

		obj = @addObject @map, 40, 300, 160, 32
		
		console.log obj.static
		
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

		object = @addObject @map, 64, 0, 32, 32, false

		@clients[spark.id] =
			map: @map
			object: object
			spark: spark

		# always make players join hub world first
		spark.join "map:#{@clients[spark.id].map.id}"
		
		spark.on "data", (data) => @netserver.handleData spark, data
		
		@netserver.setMap spark, @map

	disconnection: (spark) =>
		spark.leave "map:#{@clients[spark.id].map.id}"

		delete @clients[spark.id]

	addObject: (map, x, y, width, height, _static = yes) ->
		obj = new GameObject map, {x, y, width, height}
		obj.id = id.generate()
		obj.static = _static

		obj.setYAcceleration 10 if not _static
		obj.setYTargetVelocity 50 if not _static

		map.objects.push obj
		
		console.log obj

		obj

	tick: =>
		for map in @maps
			for obj in map.objects
				if(!obj.static)
					obj.update 1/@tickRate

			map.collision()

		setTimeout @tick, @tickRate