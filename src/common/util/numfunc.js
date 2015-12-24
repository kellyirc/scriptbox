module.exports = class NumFunc {
    static stepTowards(initial, target, step) {
        var returnValue;
        if (Math.abs(target-initial) < step) {
            returnValue = target;
        }
        else if (initial > target) {
            returnValue = initial - step;
        } 
        else {
            returnValue = initial + step;
        }
        return returnValue;
    }
};