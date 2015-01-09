Rect = require './util/rect'

module.exports = class Object
	constructor: ({@x, @y, @width, @height}) ->
		@bounds = new Rect {
			x: @x + @width/2
			y: @y + @height/2
			@width, @height
		}