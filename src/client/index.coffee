global.PIXI = require 'phaser/dist/pixi'
global.Phaser = require 'phaser/dist/phaser-no-libs'

window.onload = ->
	global.primus = new Primus

	game = new Phaser.Game 640, 480, Phaser.AUTO

	game.state.add 'main', new (require './state-main'), yes