path = require 'path'
querystring = require 'querystring'

http = require 'http'
Primus = require 'primus'
express = require 'express'
morgan = require 'morgan'
serveStatic = require 'serve-static'

# express
app = express()

app.use morgan()

app.use serveStatic path.join __dirname, '..', '..', 'public'

# routes go here

server = http.createServer app
primus = new Primus server

primus.use 'rooms', require 'primus-rooms'

server.listen 12124

# game
Game = require './game'

game = new Game primus
game.tick()