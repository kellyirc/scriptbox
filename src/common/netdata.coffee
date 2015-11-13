module.exports = class NetData
	constructor: (type, value, state)  ->
		@type = type
		@value = value
		@state = state
		@time = Date.now
		