$ ->
    
    connect = io.connect()

    num = 0

    connect.on 'connect', ->

        $('body').text @socket.sessionid

        toBeHost = =>
            this.emit 'host', ($room) ->
                num++
                roomAddr = "#{location.href}##{$room}"
                $('body').append "<br><a href='#{roomAddr}' target='_blank'>room addr</a>"
                console.log "start new room: #{$room}"

        room = location.hash[1..]

        if room
            this.emit 'knock', room, ($join) ->
                if $join
                    console.log 'Im in!'
                else
                    toBeHost()
        else
            toBeHost()

    connect.on 'room-io', ($isJoin, $name) ->
        num = if $isJoin then num + 1 else num - 1

        if num is 5
            console.log '5 people'
            this.emit 'chat', '==== we have 5 people in room ===='

        if $isJoin
            console.log "new guy #{$name} joined us."
        else
            console.log "the guy #{$name} has left us."

    connect.on 'chat', ($name, $msg) ->
        console.error "#{$name}: #{$msg}"


