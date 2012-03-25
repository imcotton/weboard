
$ ->

    service = new Service

    service
        .on 'sio:chat', ->
            console.log arguments

        .on 'sio:room-io', ->
            console.log arguments



    $('a').click -> false

    main = $('#main')
    landing = main.find '.landing'

    landing.find('.host').click ->
        landing.find('a').addClass 'disabled'

        service.connect().done ->
            @host().done ($room) ->
                url = "#{location.href}##{$room}"
                info = $('.info-bar.tmpl').clone().removeClass 'tmpl'
                info.find('.qrimg').attr href: url
                info.find('.info-block pre').text $room
                info.find('.info-block a').text(url).attr href: url
                info.prependTo 'body'





