module Krack
  class Router
    attr_reader :routes

    def initialize(&block)
      @routes = []
      instance_eval(&block) if block
    end

    def call(env)
      @routes.each do |verb, route, app|
        next unless verb == env["REQUEST_METHOD"]
        next unless match = env["PATH_INFO"].match(route)

        env["krack.params"] = Hash[match.names.zip(match.captures)]
        return app.call(env)
      end
      not_found
    end

    def not_found
      [404, {"Content-Type" => "text/plain"}, ["Not found"]]
    end

    # Defines methods for each HTTP verb. These methods just call #map
    # with the corresponding verb argument.
    %w[get post put delete patch options].each do |verb|
      define_method(verb) do |route, to, matchers={}|
        map(verb.upcase, route, to, matchers)
      end
    end

    def map(verb, route, to, matchers={})
      # Converts route params (`:id` in `/widgets/:id`) to regex named
      # groups. For example, `:id` -> `/(?<id>\w+)/`
      route.gsub!(/:\w+/) do |param|
        param.slice!(0)
        matcher = matchers[param.to_sym] || /\w+/
        /(?<#{param}>#{matcher})/
      end

      # Allow optional trailing slash, add start/end tokens
      route = /\A#{route}\/?\z/

      @routes << [verb, route, to]
    end
  end
end