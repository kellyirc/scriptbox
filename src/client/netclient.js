var NetData = require('../common/netdata');
var _ = require('lodash');
// var MainState = require('./state-main');
var GameObject = require('../common/object');
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
                        this.updateMap(phaserState, data.value); 
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
            state.setObjectGraphics(state.map.objects[obj], state.map.objects[obj].color);
        }
    }
    
    updateMap(state, objectsDiff) {
        for (var obj in objectsDiff.changes) {
            var change = GameObject.revive(objectsDiff.changes[obj]);
            change.map = state.map;
            if (!_.isUndefined(state.map.objects[change.id.toString()])) {
                _.assign(state.map.objects[change.id.toString()], change);
            }
            else {
                // Object doesn't exist clientside
                objectsDiff.additions.push(change);
            }
        }
        for (var obj2 in objectsDiff.additions) {
            var addition = GameObject.revive(objectsDiff.additions[obj2]);
            addition.map = state.map;
            if (!_.isUndefined(state.map.objects[addition.id.toString()])) {
                delete state.map.objects[addition.id.toString()];
            }
            state.map.objects[addition.id.toString()] = GameObject.revive(addition);
            if (_.isObject(state.map.objects[addition.id.toString()])) {
                state.map.objects[addition.id.toString()].map = state.map;
                state.setObjectGraphics(state.map.objects[addition.id.toString()], state.map.objects[addition.id.toString()].color);
            }
        }
        for (var obj3 in objectsDiff.removals) {
            var removal = objectsDiff.removals[obj3];
            if (!_.isUndefined(state.map.objects[removal.id.toString()])) {
                delete state.map.objects[removal.id.toString()];
            }
        }
    }
};