exports = module?.exports or @

class Item

    constructor: ($element) ->
        @info = 
            key: $element.getAttribute 'key'
            back: $element.getAttribute 'fallback'

    isValid: ->
        @info.key? and @info.back?

    create: ->
        return if @info.key of exports
        document.write "<script src='#{@info.back}'>\x3C/script>"


for i in document.getElementsByTagName 'script'
    item = new Item(i)
    item.create() if item.isValid()
