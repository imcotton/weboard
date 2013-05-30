angular.module('App', @modules)

    .config ($routeProvider, $locationProvider) ->

        $locationProvider.html5Mode(true).hashPrefix('')

        partials = (path) -> "partials/#{path}"

        $routeProvider

            .when '/',
                templateUrl: partials 'entry.tpl.html'
                controller: 'EntryCtrl as entry'

            .when '/room/:id',
                templateUrl: partials 'room.tpl.html'
                controller: 'RoomCtrl as room'

                resolve:
                    _: ($route, $location, $q, $timeout, connect) ->

                        defer = $q.defer()

                        $timeout ->
                            return defer.resolve() if connect.hasConnected()

                            connect.guest($route.current.params.id)

                                .then ->
                                    defer.resolve()

                                .then null, ->
                                    $location.path '/'

                        defer.promise



angular.bootstrap document, ['App']
