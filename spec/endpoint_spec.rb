require_relative 'spec_helper'

class TestEndpoint < Krack::Endpoint
  def respond
    throw :halt, 400 if params["halt"] == "1"
    raise if params["error"] == "1"

    {
      root: {
        int_key: 1,
        str_key: "foo bar",
        arr_key: ["one", "two"],
        test_param: params["test"]
      }
    }
  end
end

def app
  Krack::Router.new { get "/", TestEndpoint }
end

describe TestEndpoint do
  it "should succeed" do
    get "/"
    json = assert_json
    json["root"]["int_key"].must_equal 1
    json["root"]["str_key"].must_equal "foo bar"
    json["root"]["arr_key"].must_equal ["one", "two"]
  end

  it "should receive parameters" do
    get "/", :test => "wibble"
    json = assert_json
    json["root"]["test_param"].must_equal "wibble"
  end

  it "should halt" do
    get "/", :halt => "1"
    json = assert_json(400)
    json["root"].must_be_nil
  end

  it "should catch exceptions" do
    get "/", :error => "1"
    json = assert_json(500)
    json["root"].must_be_nil
  end
end
