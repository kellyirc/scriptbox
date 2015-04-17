Keyboard = require './keyboard'

module.exports = class Character extends GameObject
	constructor: ->
		@keyboard = new Keyboard