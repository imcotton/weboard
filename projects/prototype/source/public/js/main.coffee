
service = new Service

$ ->

    class Landing extends Backbone.View

        el: $ '#main .landing'

        initialize: ->
            @service = @options.service

        checkHash: ->
            if hash = window.location.hash?[1..]
                @$el.find('.default > button.guest').click()
                @$el.find('.guesting input').val hash
                @$el.find('.guesting button.join').click()

        onLogin: ($room) =>
            {href, hash} = window.location
            url = href.replace(hash, '') + "##{$room}"
        
            info = $ Tmpl.info_bar
                url: url
                room: $room

            info.prependTo 'body'

            $('<img>', src: utils.getQRCodeImg(url)).one 'load', ->
                info.find('.qrimg img').replaceWith @
                $('body').css 'padding-top', $('.info-bar').height() + 3
                $('body').css 'padding-bottom', $('.typing-bar').height() + 2

            @$el.remove()
            @trigger 'onLogin'

        clickHost: ->
            @$el.find('.default > button').attr 'disabled', 'disabled'
            service.host().done @onLogin

        clickGuest: ->
            @$el.find('.default').hide()
            @$el.find('.guesting').show()

            @$el.find('.guesting > .form > input').focus()

        clickCancel: ->
            @$el.find('.default').show()
            @$el.find('.guesting').hide()

            form = @$el.find('.guesting > .form').removeClass('error')
            form.find('input').val ''
            form.find('button.join').removeAttr 'disabled'

        clickJoin: ($event) ->
            room = @$el.find('.guesting .text').val()
            return if !room

            a = $($event.target).attr 'disabled', 'disabled'

            @service.guest(room)
                .done(@onLogin)
                .fail =>
                    a.removeAttr 'disabled'
                    @$el.find('.guesting > .form')
                        .addClass('error')
                        .find('input').select()

        events:
            'click .default > .host': 'clickHost'
            'click .default > .guest': 'clickGuest'

            'click .guesting button.join': 'clickJoin'
            'click .guesting > .cancel': 'clickCancel'


    class Typing extends Backbone.View

        text: -> @textarea.val()

        initialize: ->
            @setElement $ Tmpl.typing_bar()
            @service = @options.service

            @textarea = @$el.find('textarea.text')

        render: =>
            @$el.appendTo 'body'
            @textarea.select()

        onSend: ->
            return if !@text()

            @model.add
                text: @text()
                from: service.sid
                date: new Date

            service.chat @text()

            @textarea.val ''
            @textarea.select()

        onKeydown: ($event) ->
            if (_.indexOf [10, 13], $event.which) isnt -1 and !$event.shiftKey
                $event.preventDefault()
                @onSend()

        events:
            'click button.send': 'onSend'
            'keydown textarea.text': 'onKeydown'


    class ItemListView extends Backbone.View

        el: $ '#main'

        initialize: ->
            @model.on 'add', @onAdded

        onAdded: ($item) =>
            pre = $('<pre/>').text($item.get('text')).appendTo @$el

            urls = pre.text().match /(https?:\/\/[^\s]+)/g

            if urls?.length
                ol = $('<ol>')
                for i in urls
                    ol.append $('<li>').append "<a href='#{i}' target='_blank'>#{i}</a>"
                ol.appendTo @$el

            $('html,body').animate scrollTop: @$el.height()


    class ItemModel extends Backbone.Model

        defaults:
            text: null
            from: null
            date: null


    class ItemList extends Backbone.Collection

        model: ItemModel


    itemList = new ItemList

    typing = new Typing
        model: itemList
        service: service

    itemListView = new ItemListView
        model: itemList

    landing = new Landing
        service: service
    landing.on 'onLogin', typing.render
    landing.checkHash()


    service
        .on 'sio:chat', ($data) ->
            itemList.add new ItemModel
                text: $data.text
                from: $data.from
                date: $data.date

        .on 'sio:room-io', ->
            #console.log arguments

