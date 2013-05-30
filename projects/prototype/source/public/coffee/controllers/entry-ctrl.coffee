angular.module('controller')

    .controller 'EntryCtrl', class

        constructor: (@$scope, @$location, @connect) ->

        host: ->
            @connect.host().then (room) =>
                @$location.path "/room/#{room}"

        guest: (passcode) ->

            @connect.guest(passcode)

                .then (room) =>
                    @$location.path "/room/#{room}"

                .then null, =>
                    @$scope.sorry = true

