NetData = require '../common/netdata'
MainState = require '../client/state-main'

module.exports = class NetClient
	constructor: (state, ip, port) ->
		@ip = ip
		@port = port
		@state = state
		
	handleData: (data) =>
		switch data.type
			when "map"
				switch data.state
					when "set"
						@setMap data.value
					when "update"
						@setMap data.value
		
	keyPress: (event) ->
		global.primus.write new NetData("key", event.keyCode, "press")
		
	keyRelease: (event) ->
		global.primus.write new NetData("key", event.keyCode, "release")
		
	setMap: (map) ->
		console.log "hfvjklshdbgk"
		delete state.map
		state.map = map
		for obj in map.objects
			console.log obj
			
		
		