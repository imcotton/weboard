
class Service

    constructor: ->
        _.extend @, Backbone.Events


    sessionid: => @sio?.socket?.sessionid


    connect: ->
        defer = $.Deferred();

        @sio = io.connect()

            .on 'connect', =>
                defer.resolveWith @

            .on 'chat', =>
                @trigger 'sio:chat', arguments...

            .on 'room-io', =>
                @trigger 'sio:room-io', arguments...

        defer.promise()


    host: ->
        defer = $.Deferred();

        @sio.emit 'host', defer.resolve

        defer.promise()


    guest: ($room) ->
        defer = $.Deferred();

        @sio.emit 'knock', $room, ($hasJoin) ->
            if $hasJoin then defer.resolve()
            else defer.reject()

        defer.promise()





window.Service = Service
