var Map = require('../common/map');
var GameObject = require('../common/object');
var NetClient = require('./netclient');

module.exports = class MainState extends Phaser.State {
    constructor() {
        super();
        this.update = this.update.bind(this);
    }
    preload() {
    }
    create() {
        var ip = 'localhost';
        var port = '12123';
        this.map = new Map();
        
        this.netClient = new NetClient(this, ip, port);
        this.input.keyboard.addCallbacks(null, this.netClient.keyPress, this.netClient.keyRelease);
        
        console.log('Setting up callbacks.');
        
        global.primus.on('open', () => {
            console.log('Connected to server!');
        });
        
        global.primus.on('data', (data) => {
            this.netClient.handleData(this, data);
        });
        global.primus.on('error', (err) => {
            console.error('', err.stack);
        });
        
    }
    addObject(x, y, width, height, color, _static = true) {
        var obj = new GameObject(this.map, { x: x, y: y, width: width, height: height });
        obj.immovable = _static;
        
        obj.setYAcceleration(_static ? 10 : 0); 
        obj.setYTargetVelocity(_static ? 50 : 0); 
        
        obj.color = color;
        
        this.map.add(obj);
        
        obj.graphics = this.setObjectGraphics(obj, obj.color);
        
        return obj;
    }
    setObjectGraphics(obj, color) {
        obj.graphics = this.game.add.graphics(obj.bounds.x, obj.bounds.y);
        
        obj.graphics.beginFill(color, 1);
        return obj.graphics.drawRect(0, 0, obj.bounds.width, obj.bounds.height);
    }
    update() {
        for (var i2 in this.map.objects) {
            var obj2 = this.map.objects[i2];
            obj2.graphics.x = obj2.bounds.left;
            obj2.graphics.y = obj2.bounds.top;
        }
    }
};