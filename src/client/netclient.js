var NetData = require('../common/netdata');
// var _ = require('lodash');
// var MainState = require('./state-main');
// var GameObject = require('../common/object');
var Map = require('../common/map');

module.exports = class NetClient {
    constructor(state, ip, port) {
        this.ip = ip;
        this.port = port;
        this.state = state;
    }
    
    handleData(phaserState, data) {
        switch (data.type) {
            case 'map':
                switch (data.state) {
                    case 'set':
                        this.setMap(phaserState, data.value); 
                        break;
                    case 'update':
                        this.setMap(phaserState, data.value); 
                        break;
                        
                }
                
        }
    }
    
    keyPress(event) {
        global.primus.write(new NetData('key', event.keyCode, 'press'));
    }
    
    keyRelease(event) {
        global.primus.write(new NetData('key', event.keyCode, 'release'));
    }
    
    setMap(state, map) {
        delete state.map;
        state.map = Map.revive(map);
        for (var obj in map.objects) {
            state.setObjectGraphics(state.map.objects[obj], 0xFFFFFF);
        }
    }
};