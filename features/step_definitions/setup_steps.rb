Given /^a rack (with|without) the session middleware$/ do |prep|
  @rack_builder = Rack::Builder.new
  @rack_builder.use Rack::Lint
  @rack_builder.use FakeSession if prep == 'with'
end

# Yes, they're not as DRY as possible, but I think they're more readable than
# a single step definition with a few captures and more complex checkings.

Given /^a rack with the anti\-CSRF middleware$/ do
  step 'a rack with the session middleware'
  step 'I insert the anti-CSRF middleware'
end

Given /^a rack with the anti\-CSRF middleware and the :raise option$/ do
  step 'a rack with the session middleware'
  step 'I insert the anti-CSRF middleware with the :raise option'
end

Given /^a rack with the anti\-CSRF middleware and the :skip option$/ do |table|
  step 'a rack with the session middleware'
  step 'I insert the anti-CSRF middleware with the :skip option', table
end

Given /^a rack with the anti\-CSRF middleware and the :skip_if option$/ do |table|
  step 'a rack with the session middleware'
  step 'I insert the anti-CSRF middleware with the :skip_if option', table
end

Given /^a rack with the anti\-CSRF middleware and both the :skip and :skip_if options$/ do |table|
  step 'a rack with the session middleware'
  step 'I insert the anti-CSRF middleware with the :skip and :skip_if options', table
end

Given /^a rack with the anti\-CSRF middleware and the :field option$/ do
  step 'a rack with the session middleware'
  step 'I insert the anti-CSRF middleware with the :field option'
end

Given /^a rack with the anti\-CSRF middleware and the :key option$/ do
  step 'a rack with the session middleware'
  step 'I insert the anti-CSRF middleware with the :key option'
end

Given /^a rack with the anti\-CSRF middleware and the :check_also option$/ do |table|
  step 'a rack with the session middleware'
  step 'I insert the anti-CSRF middleware with the :check_also option', table
end

Given /^a rack with the anti\-CSRF middleware and the :check_only option$/ do |table|
  step 'a rack with the session middleware'
  step 'I insert the anti-CSRF middleware with the :check_only option', table
end

# Yes, they're not as DRY as possible, but I think they're more readable than
# a single step definition with a few captures and more complex checkings.

When /^I insert the anti\-CSRF middleware$/ do
  @rack_builder.use Rack::Csrf
  @app = toy_app
  @browser = Rack::Test::Session.new(Rack::MockSession.new(@app))
end

When /^I insert the anti\-CSRF middleware with the :raise option$/ do
  @rack_builder.use Rack::Csrf, :raise => true
  @app = toy_app
  @browser = Rack::Test::Session.new(Rack::MockSession.new(@app))
end

When /^I insert the anti\-CSRF middleware with the :skip option$/ do |table|
  skippable = table.hashes.collect {|t| t.values}.flatten
  @rack_builder.use Rack::Csrf, :skip => skippable
  @app = toy_app
  @browser = Rack::Test::Session.new(Rack::MockSession.new(@app))
end

When /^I insert the anti\-CSRF middleware with the :skip_if option$/ do |table|
  skippable = table.hashes.collect {|t| t.values}
  @rack_builder.use Rack:: Csrf, :skip_if => Proc.new { |request|
    skippable.any? { |name, value| request.env[name] == value }
  }
  @app = toy_app
  @browser = Rack::Test::Session.new(Rack::MockSession.new(@app))
end

When /^I insert the anti\-CSRF middleware with the :skip and :skip_if options$/ do |table|
  data = table.hashes.collect {|t| t.values}[0]
  headers = data[0..1]
  skippable = data[2]

  @rack_builder.use Rack:: Csrf, :skip => [skippable], :skip_if => Proc.new { |request|
    skippable.any? { |name, value| request.env[name] == value }
  }
  @app = toy_app
  @browser = Rack::Test::Session.new(Rack::MockSession.new(@app))
end

When /^I insert the anti\-CSRF middleware with the :field option$/ do
  @rack_builder.use Rack::Csrf, :field => 'fantasy_name'
  @app = toy_app
  @browser = Rack::Test::Session.new(Rack::MockSession.new(@app))
end

When /^I insert the anti\-CSRF middleware with the :key option$/ do
  @rack_builder.use Rack::Csrf, :key => 'fantasy_name'
  @app = toy_app
  @browser = Rack::Test::Session.new(Rack::MockSession.new(@app))
end

When /^I insert the anti\-CSRF middleware with the :check_also option$/ do |table|
  check_also = table.hashes.collect {|t| t.values}.flatten
  @rack_builder.use Rack::Csrf, :check_also => check_also
  @app = toy_app
  @browser = Rack::Test::Session.new(Rack::MockSession.new(@app))
end

When /^I insert the anti\-CSRF middleware with the :check_only option$/ do |table|
  must_be_checked = table.hashes.collect {|t| t.values}.flatten
  @rack_builder.use Rack::Csrf, :check_only => must_be_checked
  @app = toy_app
  @browser = Rack::Test::Session.new(Rack::MockSession.new(@app))
end

Then /^I get a fully functional rack$/ do
  expect {Rack::MockRequest.new(@app).get('/')}.to_not raise_exception
end

Then /^I get an error message$/ do
  expect {Rack::MockRequest.new(@app).get('/')}.to raise_exception(
    Rack::Csrf::SessionUnavailable,
    'Rack::Csrf depends on session middleware')
end

def toy_app
  @rack_builder.run(lambda {|env| Rack::Response.new('Hello world!').finish})
  @rack_builder.to_app
end
