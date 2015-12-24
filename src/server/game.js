var Map = require('../common/map');
var GameObject = require('../common/object');
var id = require('../common/id-generation');
var NetServer = require('./netserver');

module.exports = class Game {
    constructor(primus) {
        
        this.connection = this.connection.bind(this);
        this.disconnection = this.disconnection.bind(this);
        this.tick = this.tick.bind(this);
        
        this.primus = primus;
        this.maps = [];
        this.clients = {};
        this.tickRate = 1000/10;
        this.map = new Map();
        this.addObject(this.map, 40, 300, 160, 32, true);
        
        this.map.id = 'hub';
        this.maps.push(this.map);
        
        this.netServer = new NetServer();
        
        this.primus.on('connection', this.connection);
        this.primus.on('disconnection', this.disconnection);
        this.primus.on('joinroom', (room, spark) => console.log(spark.address, 'joined', room));
        this.primus.on('leaveroom', (room, spark) => console.log(spark.address, 'left', room));
        this.primus.on('error', function(err) {
            console.log(err.stack);
        });
    }
    
    connection(spark) {
        console.log('Connection!', spark.address);
        var object = this.addObject(this.map, 64, 0, 32, 32, false);
        this.clients[spark.id] = {
            map: this.map,
            object: object,
            spark: spark
        };
        
        // Always make players join the hub world first
        spark.join('map:#{@clients[spark.id].map.id}');
        spark.on('data', (data) => this.netServer.handleData(spark, data));
        this.netServer.setMap(spark, this.map);
    }
    
    disconnection(spark) {
        spark.leave('map:#{@clients[spark.id].map.id}');
        delete this.clients[spark.id];
    }
    
    addObject(map, x, y, width, height, _static = true) {
        var obj = new GameObject(map, { x: x, y: y, width: width, height: height });
        obj.id = id.generate();
        obj.immovable = _static;
        
        obj.setYAcceleration(_static ? 0 : 10);
        obj.setYTargetVelocity(_static ? 0 : 50);
        
        map.objects.push(obj);
        
        return obj;
    }
    
    tick() {
        for (var map in this.maps) {
            for(var obj in this.maps[map].objects) {
                if (!this.maps[map].objects[obj].immovable) {
                    this.maps[map].objects[obj].update(1/this.tickRate);
                }
            }
            this.maps[map].collision();
        }
        
        setTimeout(this.tick, this.tickRate);
    }
};