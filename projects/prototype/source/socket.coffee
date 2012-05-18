io = require 'socket.io'

exports.init = ($http) ->

    io = io.listen $http

    io.configure 'production', ->

        io.set 'log level', 1

        io.enable 'browser client minification'
        io.enable 'browser client etag'
        io.enable 'browser client gzip'

        io.set 'transports', [
            'websocket'
            'xhr-polling'
            'jsonp-polling'
            'htmlfile'
        ]

    io.configure 'development', ->

        io.set 'log level', 2

        io.set 'transports', [
            'websocket'
        ]


    house = {}
    roomPefix = 'room-'

    io.sockets.on 'connection', ($socket) ->

        $socket.once 'host', ($fn) ->
            num = "#{@id}"[...5]
            @room = "#{roomPefix}#{num}"
            house[@room] = 1
            this.join @room
            $fn num

        $socket.on 'knock', ($room, $fn) ->
            room = "#{roomPefix}#{$room}"
            if room of house
                @room = room
                this.join @room
                house[@room]++
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
            return unless @room of house

            this.leave @room
            house[@room]--
            this.broadcast.to(@room).emit 'room-io', false, @id

            delete house[@room] unless house[@room]



