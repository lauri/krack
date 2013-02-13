# Krack

Simple JSON APIs on Rack. Like so:

    # config.ru
    
    require 'krack'
    
    module Widgets
      class Show
        def respond
          widget = Widget.find(params["id"])
          {widget: widget.as_json}
        end
      end
    end

    run Krack::Router.new {
      get "/widgets/:id", Widgets::Show
    }