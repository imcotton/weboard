
service = new Service

service
    .on 'sio:chat', ->
        console.log arguments

    .on 'sio:room-io', ->
        console.log arguments


$ ->

    class Landing extends Backbone.View

        el: $ '#main .landing'

        onLogin: ($room) =>
            {origin, pathname} = location
            url = "#{origin + pathname}##{$room}"
        
            info = $ Tmpl.info_bar
                url: url
                room: $room

            info.prependTo 'body'

            $('<img>', src: utils.getQRCodeImg(url)).one 'load', ->
                info.find('.qrimg img').replaceWith @
                $('body').css 'padding-top', info.height() + 20;

            @$el.remove()

        clickHost: ->
            @$el.find('a').addClass 'disabled'

            service.host().done @onLogin

        clickGuest: ->
            @$el.find('.default').hide()
            @$el.find('.guesting').show()

            @$el.find('.guesting > .form > input').focus()

        clickCancel: ->
            @$el.find('.default').show()
            @$el.find('.guesting').hide()

            @$el.find('.guesting > .form').removeClass('error')
                .find('input').val ''

        clickJoin: ->
            room = @$el.find('.guesting .text').val()
            return if !room

            service.guest(room)
                .done(@onLogin)
                .fail =>
                    @$el.find('.guesting > .form')
                        .addClass('error')
                        .find('input').select()

        events:
            'click .default > .host': 'clickHost'
            'click .default > .guest': 'clickGuest'

            'click .guesting a.join': 'clickJoin'
            'click .guesting > .cancel': 'clickCancel'


    landing = new Landing


