module Krack
  class Endpoint
    attr_reader :env, :request, :response, :params

    def call(env)
      dup.call!(env)
    end

    def call!(env)
      @env      = env
      @request  = Rack::Request.new(env)
      @response = Rack::Response.new([], 200, {"Content-Type" => "application/json"})
      @params   = env["krack.params"].merge(@request.params)

      on_call
      data = begin
        respond_or_halt
      rescue
        on_error($!)
      end

      @response.write(output(data))
      @response.finish
    end

    def respond_or_halt
      halt = catch(:halt) { return respond }
      on_halt(halt)
    end

    def on_call; end

    def on_error(error)
      on_halt(500)
    end

    def on_halt(halt)
      e = Krack::Error.new(halt)
      response.status = e.status
      e.to_h
    end

    def output(data)
      MultiJson.dump(data, :time_format => :ruby)
    end

    def respond
      raise "#respond method is not defined in #{self.class}"
    end
  end
end
