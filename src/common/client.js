// var LevelFunc = require('./util/levelfunc');
var Keyboard = require('./keyboard');

module.exports = class Client {
    constructor() {
        this.exp = 0;
        this.level = 1;
        this.keyboard = new Keyboard();
    }
};