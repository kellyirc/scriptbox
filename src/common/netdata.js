module.exports = class NetData {
    constructor(type, value, state) {
        this.type = type;
        this.value = value;
        this.state = state;
        this.time = Date.now();
    }
};