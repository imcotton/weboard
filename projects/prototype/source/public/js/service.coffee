
class Service

    constructor: ->
        _.extend @, Backbone.Events


    host: ->
        defer = $.Deferred();

        beHost = ->
            @sio.emit 'host', ($room) =>
                @room = $room
                defer.resolveWith @, [$room]

        if @sid then beHost.call @
        else @_connect().done beHost

        defer.promise()


    guest: ($room) ->
        defer = $.Deferred();

        beGuest = ->
            @sio.emit 'knock', $room, ($roomAuth) ->
                if $roomAuth then defer.resolveWith @, [$roomAuth]
                else defer.reject()

        if @sid then beGuest.call @
        else @_connect().done beGuest

        defer.promise()


    chat: ($msg) ->
        @sio.emit 'chat', $msg


    _connect: ->
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





window.Service = Service
