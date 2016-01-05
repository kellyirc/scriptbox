var Map = require('../common/map');
var GameObject = require('../common/object');
var Player = require('../common/player');
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
        this.tickRate = 1000/60;
        this.lastTick = 0;
        this.map = new Map();
        this.addObject(this.map, 40, 300, 860, 32, 0xFFFFFF, true);
        
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
        var object = this.addPlayer(this.map, 64, 0, 32, 32, parseInt(spark.address.ip.replace('.', '')) % 0x1000000, false);
        this.clients[spark.id] = {
            map: this.map,
            object: object,
            spark: spark
        };
        
        // Always make players join the hub world first
        spark.join('map:#{@clients[spark.id].map.id}');
        spark.on('data', (data) => this.netServer.handleData(this.clients[spark.id], data));
        this.netServer.setMap(spark, this.map);
    }
    
    disconnection(spark) {
        spark.leave('map:#{@clients[spark.id].map.id}');
        this.map.remove(this.clients[spark.id].object);
        delete this.clients[spark.id];
    }
    
    addObject(map, x, y, width, height, color, _static = true) {
        var obj = new GameObject(map, { x: x, y: y, width: width, height: height });
        obj.id = id.generate();
        obj.immovable = _static;
        
        obj.setYAcceleration(_static ? 0 : 10);
        obj.setYTargetVelocity(_static ? 0 : 50);
        
        obj.color = color;
        
        map.add(obj);
        
        return obj;
    }
    
    addPlayer(map, x, y, width, height, color, _static = true) {
        var obj = new Player(map, { x: x, y: y, width: width, height: height });
        obj.id = id.generate();
        obj.immovable = _static;
        
        obj.setYAcceleration(_static ? 0 : 10);
        obj.setYTargetVelocity(_static ? 0 : 50);
        
        obj.color = color;
        
        map.add(obj);
        
        return obj;
    }
    
    tick() {
        if (Date.now() - this.lastTick > this.tickRate) {
            console.log(Date.now() - this.lastTick);
            this.lastTick = Date.now();
            this.updateMaps();
            this.updateClients();
        }
        setImmediate(this.tick);
    }
    
    updateMaps() {
        for (var map in this.maps) {
            this.maps[map].update(1/this.tickRate);
        }
    }
    
    updateClients() {
        for (var client in this.clients) {
            this.netServer.updateMap(this.clients[client].spark, this.clients[client].map.objectsDiff); 
        }
    }
};