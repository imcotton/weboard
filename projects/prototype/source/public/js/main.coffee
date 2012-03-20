
$ ->

    return
    
    service = new Service

    service.connect().done ->
        $('body').text @sessionid

    service
        .on 'sio:chat', ->
            console.log arguments

        .on 'sio:room-io', ->
            console.log arguments




