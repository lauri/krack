require 'minitest/autorun'
require 'minitest/spec'
require 'rack/test'

require_relative '../lib/krack'

include Rack::Test::Methods

class MiniTest::Spec
  def assert_json(status=200)
    last_response.status.must_equal status
    last_response.content_type.must_equal "application/json"
    JSON.parse(last_response.body)
  end
end
