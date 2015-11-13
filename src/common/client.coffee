LevelFunc = require './util/levelfunc'
Keyboard = require './keyboard'

module.exports = class Client
	constructor: ->
		@exp = 0
		@level = 1
		@keyboard = new Keyboard