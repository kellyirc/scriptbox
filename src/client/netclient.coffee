NetData = require '../common/netdata'
module.exports = class NetClient
	constructor: (ip, port) ->
		@ip = ip
		@port = port
		
	keyPress: (event) ->
		global.primus.write new NetData("key", event.keyCode, "press")
		
	keyRelease: (event) ->
		global.primus.write new NetData("key", event.keyCode, "release")