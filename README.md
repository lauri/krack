## Krack

Simple JSON APIs on Rack. Like so:

```ruby
# config.ru
require "krack"

class Widget # < "ORM"
  DB = {
    "1" => {name: "Foo", color: "Black"},
    "2" => {name: "Bar", color: "White"}
  }
  def self.all; DB end
  def self.find(id); DB[id] end
end

module Widgets
  class Index < Krack::Endpoint
    def respond
      {widgets: Widget.all}
    end
  end

  class Show < Krack::Endpoint
    def respond
      widget = Widget.find(params["id"]) or throw :halt, 404
      {widget: widget}
    end
  end
end

run Krack::Router.new {
  get "/widgets",     Widgets::Index
  get "/widgets/:id", Widgets::Show
}
```

## License
This content is released under the [MIT License](http://opensource.org/licenses/MIT).
