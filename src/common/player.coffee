LevelFunc = require './util/levelfunc'
Keyboard = require './keyboard'

module.exports = class Player
	constructor: ->
		@exp = 0
		@level = 1
		@keyboard = new Keyboard