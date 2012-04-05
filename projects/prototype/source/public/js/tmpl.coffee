
window.Tmpl = class
    
    @info_bar = _.template.call @,
        '<div class="info-bar navbar navbar-fixed-top">
          <div class="navbar-inner">
            <div class="container">

                <div class="pull-left">
                    <a href="<%= url %>" target="_blank" class="qrimg pull-left">
                        <img src="resource/img/spinner.gif">
                    </a>
                    <div class="info-block pull-left">
                        <pre><%= room %></pre>
                        <a href="<%= url %>" target="_blank"><%= url %></a>
                    </div>
                </div>

            </div>
          </div>
        </div>'

    @typing_bar = _.template.call @,
        '<div class="typing-bar navbar navbar-fixed-bottom">
          <div class="navbar-inner">
            <div class="container">

                <div class="form form-horizontal">
                    <textarea class="text input-xlarge" rows="2"></textarea>
                    <button class="send btn btn-primary">Send</button>
                </div>

            </div>
          </div>
        </div>'
