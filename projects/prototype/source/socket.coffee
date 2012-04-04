io = require 'socket.io'

exports.init = ($http) ->

    io = io.listen $http

    io.set 'log level', 2

    rooms = {}
    roomPefix = 'room-'

    io.sockets.on 'connection', ($socket) ->

        $socket.emit 'chat', 'hello'
        
        $socket.once 'host', ($fn) ->
            @room = "#{roomPefix}#{@id}"
            rooms[@room] = true
            this.join @room
            $fn @id

        $socket.on 'knock', ($room, $fn) ->
            room = "#{roomPefix}#{$room}"
            if room of rooms
                @room = room
                this.join @room
                this.broadcast.to(@room).emit 'room-io', true, @id
                $fn $room
            else
                $fn false

        $socket.on 'chat', ($msg) ->
            this.broadcast.to(@room).emit 'chat',
                from: @id
                text: $msg
                date: new Date

        $socket.once 'disconnect', ->
            if @room of rooms
                this.leave @room
                this.broadcast.to(@room).emit 'room-io', false, @id


