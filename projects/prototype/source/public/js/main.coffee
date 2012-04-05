
service = new Service

$ ->

    class Landing extends Backbone.View

        el: $ '#main .landing'

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
                $('body').css 'padding-top', $('.info-bar').height()
                $('body').css 'padding-bottom', $('.typing-bar').height()

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

            service.guest(room)
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


        onSend: ->
            return if !@text()

            @model.add
                text: "[me] #{@text()}"
                from: service.sid
                date: new Date

            service.chat @text()

            @textarea.val ''
            @textarea.select()


        onKeydown: ($event) ->
            if $event.which is 13 
                if $event.ctrlKey
                    @textarea.val @text() + '\n'
                else
                    @onSend()
                    return false
            else
                return true


        events:
            'click button.send': 'onSend'
            'keydown textarea.text': 'onKeydown'


    class ItemListView extends Backbone.View

        el: $ '#main'

        initialize: ->
            @model.on 'add', @onAdded

        onAdded: ($item) =>
            $("<p>#{$item.get('text')}</p>").appendTo @$el



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
    landing.checkHash()
    landing.on 'onLogin', ->
        typing.$el.appendTo 'body'


    service
        .on 'sio:chat', ($data) ->
            itemList.add new ItemModel
                text: $data.text
                from: $data.from
                date: $data.date

        .on 'sio:room-io', ->
            #console.log arguments

