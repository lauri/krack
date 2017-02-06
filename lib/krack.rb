require "rack"
require "json"

require "krack/version"
require "krack/error"
require "krack/router"
require "krack/endpoint"

module Krack
  extend self

  def env?(e)
    env == e.to_s
  end

  def env
    ENV["RACK_ENV"]
  end
end
