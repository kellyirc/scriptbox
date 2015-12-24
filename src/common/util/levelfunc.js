module.exports = class LevelFunc {
    level(exp) {
        return 1 + Math.floor(Math.pow(exp/100, 1/1.6));
    }
    expForLevel(level) {
        return 10 * Math.pow(level - 1, 1.6);
    }
    toNext(exp) {
        return this.expForLevel(this.level(exp) + 1, exp);
    }
};