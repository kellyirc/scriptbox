Map = require '../common/map'
GameObject = require '../common/object'
NetClient = require '../client/netclient'

module.exports = class MainState extends Phaser.State
	preload: ->

	create: ->
		ip = "localhost"
		port = "12123"
		@map = new Map
		
		@server = new NetClient @, ip, port
		@input.keyboard.addCallbacks null, @server.keyPress, @server.keyRelease
		
		console.log "setting up callbacks"
	
		global.primus.on 'open', =>
			console.log "Connected to server!"
		
		
		global.primus.on 'data', (data) =>
			console.log "data get!!"
			@server.handleData data
			
		global.primus.on 'error', (err) =>
			console.error "Error: ", err.stack
			
			

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

		@map.collision()
		
		for obj in @map.objects
			obj.graphics.x = obj.bounds.left
			obj.graphics.y = obj.bounds.top
		
		null