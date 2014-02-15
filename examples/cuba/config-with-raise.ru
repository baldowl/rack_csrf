require 'cuba'
require 'rack/csrf'

Cuba.use Rack::ShowExceptions
Cuba.use Rack::Session::Cookie
Cuba.use Rack::Csrf, :raise => true

require './app'

run Cuba
