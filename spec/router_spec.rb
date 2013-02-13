require_relative 'spec_helper'

describe Krack::Router do
  before do
    @router = Krack::Router.new {
      get "/deals",             lambda { |env| 1 }
      get "/deals/:id",         lambda { |env| 2 }
      get "/deals/foo/bar",     lambda { |env| 3 }
      post "/deals/:one/:two",  lambda { |env| 4 }
      get "/users/best",        lambda { |env| 5 }
      get "/users/:id",         lambda { |env| 6 }
    }
  end

  it "should match a simple route" do
    env = {"REQUEST_METHOD" => "GET", "PATH_INFO" => "/deals"}
    @router.call(env).must_equal 1
  end

  it "should allow trailing slash" do
    env = {"REQUEST_METHOD" => "GET", "PATH_INFO" => "/deals/"}
    @router.call(env).must_equal 1
  end

  it "should match a longer simple route" do
    env = {"REQUEST_METHOD" => "GET", "PATH_INFO" => "/deals/foo/bar"}
    @router.call(env).must_equal 3
  end

  it "should not match when request method is wrong" do
    env = {"REQUEST_METHOD" => "POST", "PATH_INFO" => "/deals"}
    @router.call(env).first.must_equal 404
  end

  it "should not allow a partial match" do
    env = {"REQUEST_METHOD" => "GET", "PATH_INFO" => "/foo/deals"}
    @router.call(env).first.must_equal 404
  end

  it "should match a route with param" do
    env = {"REQUEST_METHOD" => "GET", "PATH_INFO" => "/deals/42"}
    @router.call(env).must_equal 2
  end

  it "should populate env krack.params" do
    env = {"REQUEST_METHOD" => "GET", "PATH_INFO" => "/deals/42"}
    @router.call(env)
    env["krack.params"].must_equal({"id" => "42"})
  end

  it "should match a route with multiple params" do
    env = {"REQUEST_METHOD" => "POST", "PATH_INFO" => "/deals/42/99"}
    @router.call(env).must_equal 4
  end

  it "should choose the first defined route when multiple routes match" do
    env = {"REQUEST_METHOD" => "GET", "PATH_INFO" => "/users/best"}
    @router.call(env).must_equal 5
  end

  it "should allow non-integer params" do
    env = {"REQUEST_METHOD" => "GET", "PATH_INFO" => "/users/worst"}
    @router.call(env).must_equal 6
  end
end