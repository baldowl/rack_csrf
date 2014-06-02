require 'rubygems'
require 'rspec'
require 'rspec/collection_matchers'

require 'rack/csrf'

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :should
  end
end
