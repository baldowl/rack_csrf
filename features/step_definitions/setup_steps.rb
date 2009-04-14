Given /^a Rack setup (with|without) the session middleware$/ do |prep|
  @rack_builder = Rack::Builder.new
  @rack_builder.use Rack::Session::Cookie if prep == 'with'
end

class CsrfFaker
  def initialize(app)
    @app = app
  end
  def call(env)
    env['rack.session']['rack.csrf'] = 'right_token'
    @app.call(env)
  end
end

Given /^a Rack setup with the anti\-CSRF middleware$/ do
  Given 'a Rack setup with the session middleware'
  @rack_builder.use CsrfFaker
  When 'I insert the anti-CSRF middleware into the rack'
end

Given /^a Rack setup with the anti\-CSRF middleware and the :raise option$/ do
  Given 'a Rack setup with the session middleware'
  @rack_builder.use CsrfFaker
  When 'I insert the anti-CSRF middleware with the :raise option into the rack'
end

When /^I insert the anti\-CSRF middleware into the rack$/ do
  @rack_builder.use Rack::Lint
  @rack_builder.use Rack::Csrf
  @rack_builder.run(lambda {|env| Rack::Response.new('Hello world!').finish})
  @app = @rack_builder.to_app
end

When /^I insert the anti\-CSRF middleware with the :raise option into the rack$/ do
  @rack_builder.use Rack::Lint
  @rack_builder.use Rack::Csrf, :raise => true
  @rack_builder.run(lambda {|env| Rack::Response.new('Hello world!').finish})
  @app = @rack_builder.to_app
end

Then /^I get a fully functional rack$/ do
  lambda {Rack::MockRequest.new(@app).get('/')}.should_not raise_error
end

Then /^I get an error message$/ do
  lambda {Rack::MockRequest.new(@app).get('/')}.should raise_error(Rack::Csrf::SessionUnavailable, 'Rack::Csrf depends on session middleware')
end
