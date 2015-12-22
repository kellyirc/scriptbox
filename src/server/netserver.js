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
    keyPress(spark, key, time) {
        console.log(time, ' PRESS:     ', key);
    }
    keyRelease(spark, key, time) {
        console.log(time, ' RELEASE:   ', key);
    }
    setMap(spark, map) {
        spark.write(new NetData('map', map, 'set'));
    }
};