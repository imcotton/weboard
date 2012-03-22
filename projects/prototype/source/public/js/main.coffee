
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
                info = $('.host-info.tmpl').clone().removeClass 'tmpl'
                info.find('a').attr href: url
                info.find('.link').text url
                info.find('pre').text $room
                info.appendTo landing





