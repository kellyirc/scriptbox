var GameObject = require('./object');
var _ = require('lodash');
module.exports = class Map {
    constructor() {
        this.objects = [];
        this.objectChangeHandler = null;
    }
    
    add(object) {
        object.ChangeHandler = this.objectChangeHandler;
    }
    
    remove(object) {
        return object;
    }
    
    updatePosition(object) {
        return object;
    }
    
    collision() {
        for(var obj in this.objects) {
            this.objects[obj].collided = { top: false, bottom: false, left: false, right: false };
        }
        
        for(var i in this.objects) {
            var obj1 = this.objects[i];
            for(var j in this.objects) {
                var obj2 = this.objects[j];
                this.handleCollision(obj1, obj2);
            }
        }
    }
    
    handleCollision(obj1, obj2) {
        if (obj1 == obj2) { return; }
        if (obj1.bounds.overlaps(obj2.bounds)) {
            // determine factor for displacement of objects
            var df1 = 0.5;
            df1 = obj1.immovable ? 0 : df1;
            df1 = obj2.immovable ? 1 : df1;
            
            var df2 = obj1.immovable && obj2.immovable ? 0 : 1-df1;
            
            // calculate X overlap
            var xOverlap = 0;

            var o1 = obj1.bounds.right - obj2.bounds.left;
            var o2 = obj1.bounds.left - obj2.bounds.right;
            
            xOverlap = Math.abs(o1) < Math.abs(o2) ? o1 : o2;
            
            // calculate Y overlap
            var yOverlap = 0;

            o1 = obj1.bounds.bottom - obj2.bounds.top;
            o2 = obj1.bounds.top - obj2.bounds.bottom;

            yOverlap = Math.abs(o1) < Math.abs(o2) ? o1 : o2;
            
            // separate axis with smallest overlap
            if(Math.abs(xOverlap) < Math.abs(yOverlap)) {
                obj1.x -= xOverlap * df1;
                obj2.x += xOverlap * df2;
                
                for (var m in obj1.movements) {
                    // if both velocities are the same sign
                    if (obj1.movements[m].currentVelocity.x * obj1.velocity.x > 0) {
                        obj1.movements[m].currentVelocity.x = 0;
                    }
                }
                for (var m2 in obj2.movements) {
                    // if both velocities are the same sign
                    if (this.movements[m2].currentVelocity.x * obj2.velocity.x > 0) {
                        this.movements[m2].currentVelocity.x = 0;
                    }
                }
                
                obj1.velocity.x = obj2.velocity.x = 0;

                if (xOverlap > 0) {
                    // obj1 colliding on right, obj2 colliding on left
                    obj1.collided.right = true;
                    obj2.collided.left = true;
                }
                else {
                    // obj2 colliding on left, obj1 colliding on right
                    obj1.collided.left = true;
                    obj2.collided.right = true;
                }
            }
            else {
                obj1.y -= yOverlap * df1;
                obj2.y += yOverlap * df2;
                
                for (var m3 in obj1.movements) {
                    // if both velocities are the same sign
                    if (obj1.movements[m3].currentVelocity.y * obj1.velocity.y > 0) {
                        obj1.movements[m3].currentVelocity.y = 0;
                    }
                }
                for (var m4 in obj2.movements) {
                    // if both velocities are the same sign
                    if (obj2.movements[m4].currentVelocity.y * obj2.velocity.y > 0) {
                        obj2.movements[m4].currentVelocity.y = 0;
                    }
                }
                
                obj1.velocity.y = obj2.velocity.y = 0;

                if (yOverlap > 0) {
                    // obj1 colliding on bottom, obj2 colliding on top
                    obj1.collided.bottom = true;
                    obj2.collided.top = true;
                }
                else {
                    // obj2 colliding on top, obj1 colliding on bottom
                    obj1.collided.top = true;
                    obj2.collided.bottom = true;
                }
            }
        }
    }
    
    static revive(map) {
        map = _.assign(new Map(), map);
        for(var o in map.objects) {
            map.objects[o] = GameObject.revive(map.objects[o]);
            map.objects[o].map = map;
        }
        return map;
    }
};