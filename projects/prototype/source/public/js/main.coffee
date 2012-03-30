
service = new Service

service
    .on 'sio:chat', ->
        console.log arguments

    .on 'sio:room-io', ->
        console.log arguments


$ ->

    class Landing extends Backbone.View

        el: $ '#main .landing'

        clickHost: ->
            _this = @;
            @$el.find('a').addClass 'disabled'

            service.connect().done ->
                @host().done ($room) ->
                    url = "#{location.href}##{$room}"
                
                    info = $ Tmpl.info_bar
                        url: url
                        room: $room

                    info.prependTo 'body'

                    $('<img>', src: utils.getQRCodeImg(url)).one 'load', ->
                        info.find('.qrimg img').replaceWith @
                        $('body').css 'padding-top', info.height() + 20;

                    _this.$el.remove()

        clickGuest: ->
            @$el.find('.default').hide()
            @$el.find('.guesting').show()

        clickCancel: ->
            @$el.find('.default').show()
            @$el.find('.guesting').hide()

        clickJoin: ->
            _this = @;
            service.connect().done ->
                @guest(_this.$el.find('.guesting .text').val()).done ($room) ->
                    console.log "joined #{$room}"

        events:
            'click .default > .host': 'clickHost'
            'click .default > .guest': 'clickGuest'

            'click .guesting a.join': 'clickJoin'
            'click .guesting > .cancel': 'clickCancel'


    landing = new Landing


