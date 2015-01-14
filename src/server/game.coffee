Map = require '../common/map'
GameObject = require '../common/object'

module.exports = class Game
	constructor: (@primus) ->
		@maps = []

		@tickRate = 1000/10

		@primus
		.on 'connection', @connection
		.on 'disconnection', @disconnection

	connection: (spark) =>
		console.log 'Connection!', spark.address

	disconnection: (spark) =>

	tick: =>
		for map in @maps
			for obj in map.objects
				obj.update @tickRate

		setTimeout @tick, @tickRate