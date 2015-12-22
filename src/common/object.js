var Rect = require('./util/rect');
var _ = require('lodash');
var Movement = require('./movement');

module.exports = class GameObject {
    constructor(map, arg) {
        this.type = 'GameObject';
        this.map = map;
        this.x = arg.x;
        this.y = arg.y;
        this.width = arg.width;
        this.height = arg.height;
        
        this.bounds = new Rect({
            x: (this.x - this.width / 2),
            y: (this.y - this.height / 2),
            width: this.width,
            height: this.height
        });
        
        Object.defineProperties(this, {
            x: {
                get: () => this.bounds.centerX,
                set: (v) => this.bounds.centerX = v
            },
            y: {
                get: () => this.bounds.centerY,
                set: (v) => this.bounds.centerY = v
            }
        });
        
        this.velocity = { x: 0, y: 0 };
        this.acceleration = { x: 0, y: 0 };
        this.movements = { default: new Movement() };
        this.immovable = false;
    }
    
    move(x, y) {
        this.x = x;
        this.y = y;
        
        this.map.updatePosition(this);
    }
    
    update(delta) {
        this.velocity.x = _.reduce(this.movements, (p, c) => {
            return p + c.currentVelocity.x;
        }, 0);
        this.velocity.y = _.reduce(this.movements, (p, c) => {
            return p + c.currentVelocity.y;
        }, 0);
        this.acceleration.x = _.reduce(this.movements, (p, c) => {
            return p + c.currentAcc().x;
        }, 0);
        this.acceleration.y = _.reduce(this.movements, (p, c) => {
            return p + c.currentAcc().y;
        }, 0);
        
        this.move(
            this.x + this.velocity.x * delta + (this.acceleration.x * delta * delta) / 2,
            this.y + this.velocity.y * delta + (this.acceleration.y * delta * delta) / 2
        );
        
        _.each(this.movements, (o) => o.update(delta));
    }
    
    addMovement(name = 'default', ang, targetVel, accel, currentVel) {
        if (this.movements[name]) {
            this.movements[name].adjust(ang, targetVel, accel, currentVel);
        }
        else {
            this.movements[name] = new Movement(ang, targetVel, accel, currentVel);
        }
        return this.movements[name];
    }
    
    removeMovement(name) {
        delete this.movements[name];
    }
    
    setVelocity(vel = 0, ang = 0) {
        this.movements['default'].currentVelocity.x = Math.cos(ang)*vel;
        this.movements['default'].currentVelocity.y = Math.sin(ang)*vel;
    }
    
    setXVelocity(vel = 0) {
        this.movements['default'].currentVelocity.x = vel;
    }
        
    setYVelocity(vel = 0) {
        this.movements['default'].currentVelocity.y = vel;
    }
        
    setTargetVelocity(vel = 0, ang = 0) {
        this.movements['default'].targetVelocity.x = Math.cos(ang)*vel;
        this.movements['default'].targetVelocity.y = Math.sin(ang)*vel;
    }
        
    setXTargetVelocity(vel = 0) {
        this.movements['default'].targetVelocity.x = vel;
    }
        
    setYTargetVelocity(vel = 0) {
        this.movements['default'].targetVelocity.y = vel;
    }
        
    setAcceleration(acc = 0, ang = 0) {
        this.movements['default'].acceleration.x = Math.cos(ang)*acc;
        this.movements['default'].acceleration.y = Math.sin(ang)*acc;
    }
        
    setXAcceleration(acc = 0) {
        this.movements['default'].acceleration.x = acc;
    }

    setYAcceleration(acc = 0) {
        this.movements['default'].acceleration.y = acc;
    }
    
    toJSON() {
        return _.omit(this, 'map');
    }
    
    static revive(obj) {
        var returnObj = obj;
        switch(obj.type) {
            case 'GameObject':
                var rectObj = _.pick(obj.bounds, ['x', 'y', 'width', 'height']);
                var newObj = new GameObject(obj.map, rectObj);
                returnObj =  _.assign(newObj, obj);
                returnObj.bounds = Rect.revive(returnObj.bounds, returnObj);
                var moves = returnObj.movements;
                for(var m in moves) {
                    moves[m] = Movement.revive(moves[m]);
                }
                // returnObj.movements = moves;
                break;
                
        }
        return returnObj;
    }
};