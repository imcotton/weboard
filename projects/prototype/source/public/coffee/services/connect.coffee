angular.module('service')

    .service 'connect', class extends io.EventEmitter

        constructor: (@$q, @$rootScope) ->

        hasConnected: ->
            !!@sid

        host: ->
            defer = @$q.defer()

            beHost = =>
                @sio.emit 'host', (room) =>
                    @room = room
                    @$rootScope.$apply -> defer.resolve room

            if @sid then beHost.call @
            else @_connect().then beHost

            defer.promise


        guest: (room) ->
            defer = @$q.defer()

            beGuest = =>
                @sio.emit 'knock', room, (roomAuth) =>
                    @$rootScope.$apply ->
                        if roomAuth then defer.resolve roomAuth
                        else defer.reject()

            if @sid then beGuest.call @
            else @_connect().then beGuest

            defer.promise


        chat: (msg) ->
            @sio.emit 'chat', msg


        _connect: ->
            defer = @$q.defer()

            @sio = io.connect()

                .on 'connect', =>
                    @sid = @sio.socket.sessionid
                    @$rootScope.$apply -> defer.resolve()

                .on 'chat', (data...) =>
                    @emit 'sio:chat', data...

                .on 'room-io', (data...) =>
                    @emit 'sio:room-io', data...

            defer.promise
