var NumFunc = require('./util/numfunc');
var GeneralFunc = require('./util/generalfunc');
var _ = require('lodash');

module.exports = class Movement {
    constructor(angle = 0, targetVelocity = 0, acceleration, currentVelocity) {
        this.angle = angle;
        var cos = Math.cos(this.angle);
        var sin = Math.sin(this.angle);
        this.targetVelocity = { x: cos*targetVelocity, y: sin*targetVelocity };
        this.acceleration = {
            x: (_.isNumber(acceleration) ? acceleration*sin : 0),
            y: (_.isNumber(acceleration) ? acceleration*cos : 0)
        };
        this.currentVelocity = {
            x: (_.isNumber(currentVelocity) ? currentVelocity*cos : 0),
            y: (_.isNumber(currentVelocity) ? currentVelocity*sin : 0)
        };
        if (!GeneralFunc.exists(acceleration) && !GeneralFunc.exists(currentVelocity)) {
            this.currentVelocity.x = this.targetVelocity.x;
            this.currentVelocity.y = this.targetVelocity.y;
        }
    }
    
    currentAcc() {
        var xDir = this.currentVelocity.x < this.targetVelocity.x ? 1 : -1;
        var yDir = this.currentVelocity.y < this.targetVelocity.y ? 1 : -1;
        return {
            x: this.currentVelocity.x == this.targetVelocity.x ? 0 : this.acceleration.x*xDir,
            y: this.currentVelocity.y == this.targetVelocity.y ? 0 : this.acceleration.y*yDir
        };
    }
    
    update(delta) {
        var axes = ['x', 'y'];
        for (var i in axes) {
            var a = axes[i];
            if (this.acceleration[a] != 0) {
                if (this.targetVelocity[a] != this.currentVelocity[a]) {
                    this.currentVelocity[a] = NumFunc.stepTowards(
                        this.currentVelocity[a],
                        this.targetVelocity[a],
                        this.acceleration[a]*delta
                    );
                }
            }
        }
    }
    
    // For changing the movement while it already exists
    adjust(angle, targetVelocity, acceleration, currentVelocity) {
        this.angle = angle ? angle : this.angle;
        var cos = Math.cos(this.angle);
        var sin = Math.sin(this.angle);
        if (GeneralFunc.exists(targetVelocity) || GeneralFunc.exists(angle)) {
            this.targetVelocity.x = cos*targetVelocity;
            this.targetVelocity.y = sin*targetVelocity;
        }
        if (GeneralFunc.exists(acceleration) || GeneralFunc.exists(angle)) {
            this.acceleration.x = cos*acceleration;
            this.acceleration.y = sin*acceleration;
        }
        if (GeneralFunc.exists(currentVelocity) || GeneralFunc.exists(angle)) {
            this.currentVelocity.x = cos*currentVelocity;
            this.currentVelocity.y = sin*currentVelocity;
        }
    }
    
    static revive(move) {
        var newMove = new Movement();
        console.log(move);
        newMove = _.assign(newMove, move);
        console.log(newMove);
        return newMove;
    }
};