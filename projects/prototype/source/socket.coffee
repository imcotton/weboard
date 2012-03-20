io = require 'socket.io'

exports.init = ($http) ->

    io = io.listen $http

    io.set 'log level', 2

    rooms = {}

    io.sockets.on 'connection', ($socket) ->

        $socket.emit 'chat', 'hello'
        
        $socket.once 'host', ($fn) ->
            @room = "room#{@id}"
            rooms[@room] = true
            this.join @room
            $fn @room

        $socket.once 'knock', ($room, $fn) ->
            if $room of rooms
                @room = $room
                this.join @room
                this.broadcast.to(@room).emit 'room-io', true, @id
                $fn true
            else
                $fn false

        $socket.on 'chat', ($msg) ->
            console.log "chat: #{$msg}"
            this.broadcast.to(@room).emit 'chat', @id, $msg

        $socket.once 'disconnect', ->
            if @room of rooms
                this.leave @room
                this.broadcast.to(@room).emit 'room-io', false, @id

