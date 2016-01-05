// LevelFunc = require('./util/levelfunc/');
// Keyboard = require('./keyboard');
var GameObject = require('./object');

module.exports = class Player extends GameObject {
    constructor(map, arg) {
        super(map, arg);
    }
    update(delta) {
        super.update(delta);
    }
};