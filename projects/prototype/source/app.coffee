express = require 'express'
socket = require './socket'

app = module.exports = express.createServer();

socket.init app

# Configuration

app.configure ->
    app.use express.bodyParser()
    app.use express.methodOverride()
    app.use express.static "#{__dirname}/public"

app.configure 'development', ->
    app.use express.errorHandler(
        dumpExceptions: true
        showStack: true
    )

app.configure 'production', ->
    app.use express.errorHandler()

# Routes

app.get '/', (req, res) ->
    res.sendfile "#{__dirname}/views/index.html"


app.listen 3000

console.log "Express server listening on port %d in %s mode",
    app.address().port
    app.settings.env
