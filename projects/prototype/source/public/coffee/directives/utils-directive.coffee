angular.module('directive')

    .directive 'autoScroll', ($window, $timeout) ->

        (scope, element, attrs) ->

            [watch, id] = for item in attrs.autoScroll.split ' to '
                item.trim()

            div = document.getElementById id

            scope.$watch watch, ->

                $timeout (->
                    div.scrollIntoView()
                ), 100
