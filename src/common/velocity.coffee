NumFunc = require './util/numfunc'

module.exports = class Velocity
	constructor: ->
		@targetvelocity = x: 0, y: 0
		@currentvelocity = x: 0, y: 0