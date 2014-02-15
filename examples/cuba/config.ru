require 'cuba'
require 'rack/csrf'

Cuba.use Rack::Session::Cookie
Cuba.use Rack::Csrf

require './app'

run Cuba
