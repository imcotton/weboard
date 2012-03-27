
$ ->

    service = new Service

    service
        .on 'sio:chat', ->
            console.log arguments

        .on 'sio:room-io', ->
            console.log arguments



    $('a[href="#"]').click -> false


    tmpl = $ $('script[type="text/tmpl"]').html()

    main = $('#main')
    landing = main.find '.landing'

    landing.find('.host').click ->
        landing.find('a').addClass 'disabled'

        service.connect().done ->
            @host().done ($room) ->
                url = "#{location.href}##{$room}"
                info = tmpl.find('.info-bar').clone()
                info.find('.qrimg').attr href: url
                info.find('.info-block pre').text $room
                info.find('.info-block a').text(url).attr href: url
                info.prependTo 'body'

                bodyPadding = ->
                    $('body').css 'padding-top', info.height() + 20;

                $('<img>', src: utils.getQRCodeImg(url)).one 'load', ->
                    info.find('.qrimg img').replaceWith @
                    bodyPadding()

                bodyPadding()
                landing.remove()





