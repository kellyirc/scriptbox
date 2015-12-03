NetData = require '../common/netdata'
module.exports = class NetServer
	handleData: (spark, data) =>
		switch data.type
			when "key"
				switch data.state
					when "press"
						@keyPress spark, data.value, data.time
					when "release"
						@keyRelease spark, data.value, data.time
	keyPress: (spark, key, time) ->
		console.log("PRESS:   #{key}")
		
	keyRelease: (spark, key, time) ->
		console.log("RELEASE: #{key}")
		
	setMap: (spark, map) ->
		spark.write(new NetData("map", map, "set"))