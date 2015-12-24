var Keyboard = require('./keyboard');
var GameObject = require('./object');

module.exports =  class Character extends GameObject {
    constructor() {
        super();
        this.keyboard = new Keyboard();
    }
};