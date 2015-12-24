var path = require('path');
// var querystring = require('querystring');

var http = require('http');
var Primus = require('primus');
var express = require('express');
var morgan = require('morgan');
var serveStatic = require('serve-static');
var favicon = require('serve-favicon');

// express
var app = express();

app.use(favicon(path.join(__dirname, '..', '..', 'public', 'favicon.ico')));
app.use(morgan());
app.use(serveStatic(path.join(__dirname, '..', '..', 'public')));

// routes go here

var server = http.createServer(app);
var primus = new Primus(server);

primus.use('rooms', require('primus-rooms'));

server.listen(12124);

// game
var Game = require('./game');

var game = new Game(primus);
game.tick();