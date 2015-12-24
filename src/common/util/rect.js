var _ = require('lodash');
module.exports = class Rect {
    constructor(obj) {
        this.x = 0;
        this.y = 0;
        this.width = 0;
        this.height = 0;
        
        Object.defineProperties(this, {
            left: {
                set: (v) => this.x = v,
                get: () => this.x
            },
            top: {
                set: (v) => this.y = v,
                get: () => this.y
            },
            right: {
                set: (v) => this.width = v - this.x,
                get: () => this.x + this.width
            },
            bottom: {
                set: (v) => this.height = v - this.y,
                get: () => this.y + this.height
            },
            centerX: {
                set: (v) => this.x = v - this.width/2,
                get: () => this.x + this.width/2
            },
            centerY: {
                set: (v) => this.y = v - this.height/2,
                get: () => this.y + this.height/2
            },
            center: {
                get: () => { return { x: this.centerX, y: this.centerY }; }
            }
        });
        if ('x' in obj && 'y' in obj && 'width' in obj && 'height' in obj) {
            this.x = obj.x;
            this.y = obj.y;
            this.width = obj.width;
            this.height = obj.height;
        }
        else if ('left' in obj && 'right' in obj && 'top' in obj && 'bottom' in obj) {
            this.left = obj.left;
            this.top = obj.top;
            this.right = obj.right;
            this.bottom = obj.bottom;
        }
        else if ('topLeft' in obj && 'bottomRight' in obj) {
            this.topLeft = obj.topLeft;
            this.bottomRight = obj.bottomRight;
            this.x = obj.topLeft.x;
            this.y = obj.topLeft.y;
            this.bottom = obj.bottomRight.x;
            this.right = obj.bottomRight.y;
        }
    }
    overlaps(rect) {
        return !(
            this.left > rect.right ||
            this.right < rect.left ||
            this.top > rect.bottom ||
            this.bottom < rect.top
        );
    }
    static revive(rect, owner) {
        return _.assign(new Rect(owner), rect);
    }
};