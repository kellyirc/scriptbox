var NetData = require('../common/netdata');
// var _ = require('lodash');
module.exports = class NetServer {
    handleData(spark, data) {
        switch(data.type) {
            case 'key':
                switch(data.state) {
                    case 'press':
                        this.keyPress(spark, data.value, data.time);
                        break;
                    case 'release':
                        this.keyRelease(spark, data.value, data.time);
                        break;
                }
                break;
        }
    }
    keyPress(client, key, time) {
        switch(key) {
            case 37:    // Left
                client.object.setXTargetVelocity(-10);
                break;
            case 38:    // Up
                console.log(time);
                client.object.setYVelocity(-10);
                break;
            case 39:    // Right
                client.object.setXTargetVelocity(-15);
                break;
        }
    }
    keyRelease(client, key, time) {
        console.log(time);
        switch(key) {
            case 37: case 39:    // Left, Right
                client.object.setXTargetVelocity(0);
                break;
        }
    }
    setMap(spark, map) {
        spark.write(new NetData('map', map, 'set'));
    }
    
    updateMap(spark, mapDifferences) {
        spark.write(new NetData('map', mapDifferences, 'update'));
    }
};