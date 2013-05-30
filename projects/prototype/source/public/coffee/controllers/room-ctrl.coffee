angular.module('controller')

    .controller 'RoomCtrl', class

        constructor: (@$scope, @$location, @connect) ->

            @roomURL = $location.absUrl()

            @connect

                .on 'sio:chat', (data) =>
                    {text, from, date} = data
                    @push {text, from, date}
                    @$scope.$apply()

                .on 'sio:room-io', (data) ->
                    console.log '==', data

        list: []

        push: (obj) ->
            obj.urls = obj.text.match /(https?:\/\/[^\s]+)/g
            @list.push obj

        send: (text) ->
            return unless text

            @push
                text: text
                from: @connect.sid
                date: new Date()
                self: true

            @connect.chat text

        onTyping: ($event) ->
            if $event.which in [10, 13] and !$event.shiftKey
                $event.preventDefault()

                @send @$scope.input
                @$scope.input = ''


