NetData = require '../common/netdata'
MainState = require '../client/state-main'
GameObject = require '../common/object'
Map = require '../common/map'

module.exports = class NetClient
	constructor: (state, ip, port) ->
		@ip = ip
		@port = port
		@state = state
		
	handleData: (phaserState, data) =>
		switch data.type
			when "map"
				switch data.state
					when "set"
						@setMap phaserState, data.value
					when "update"
						@setMap phaserState, data.value
		
	keyPress: (event) ->
		global.primus.write new NetData("key", event.keyCode, "press")
		
	keyRelease: (event) ->
		global.primus.write new NetData("key", event.keyCode, "release")
		
	setMap: (state, map) ->
		delete state.map
		state.map = Map.revive(map)
		for obj in state.map.objects
			state.setObjectGraphics(obj, 0xFFFFFF)
			
		
		