module.exports = class NetClient
	constructor: (ip, port) ->
		@ip = ip
		@port = port
		
	keyPress: (event) ->
		console.log("PRESS:   {event.keyCode}")
		
	keyRelease: (event) ->
		console.log("RELEASE: {event.keyCode}")