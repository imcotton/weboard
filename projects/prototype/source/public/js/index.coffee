
window.Connect = class

    sessionid: => @connection?.socket?.sessionid

    start: ->
        defer = $.Deferred();

        @connection = io.connect()
        @connection.on 'connect', =>
            ###
            TODO: hock up with:
                room-io ($jsJoin, $name)
                chat ($name, $msg)
            ###
            defer.resolveWith @

        defer.promise()


    host: ->
        defer = $.Deferred();

        @connection.emit 'host', defer.resolve

        defer.promise()


    guest: ($room) ->
        defer = $.Deferred();

        @connection.emit 'knock', $room, ($hasJoin) ->
            if $hasJoin then defer.resolve()
            else defer.reject()

        defer.promise()



$ ->

    connect = new Connect()

    connect.start().done ->
        $('body').text @sessionid




