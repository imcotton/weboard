
class Service

    constructor: ->
        _.extend @, Backbone.Events


    connect: ->
        defer = $.Deferred();

        @sio = io.connect()

            .on 'connect', =>
                @sid = @sio.socket.sessionid
                defer.resolveWith @

            .on 'chat', =>
                @trigger 'sio:chat', arguments...

            .on 'room-io', =>
                @trigger 'sio:room-io', arguments...

        defer.promise()


    host: ->
        defer = $.Deferred();

        @sio.emit 'host', ($room) =>
            @room = $room
            defer.resolveWith @, [$room]

        defer.promise()


    guest: ($room) ->
        defer = $.Deferred();

        @sio.emit 'knock', $room, ($hasJoin) ->
            if $hasJoin then defer.resolve()
            else defer.reject()

        defer.promise()





window.Service = Service
