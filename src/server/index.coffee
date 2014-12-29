path = require 'path'
querystring = require 'querystring'
https = require 'https'

express = require 'express'
morgan = require 'morgan'
serveStatic = require 'serve-static'

app = express()

app.use morgan()

app.use serveStatic path.join __dirname, '..', '..', 'public'

# routes go here

app.listen 80