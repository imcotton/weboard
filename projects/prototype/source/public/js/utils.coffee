
window.utils = class
    
    @getQRCodeImg = ($url) ->
        param = $.param
            content: $url
            size: 2
            padding: 1

        "http://www.esponce.com/api/v3/generate?#{param}"
