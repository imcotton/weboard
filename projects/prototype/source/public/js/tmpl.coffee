
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
                        <a href="<%= url %>" target="_blank"><%= room %></a>
                    </div>
                </div>

            </div>
          </div>
        </div>'
