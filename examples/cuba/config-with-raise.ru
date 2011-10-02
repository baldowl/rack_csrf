require 'cuba'
$: << File.join(File.dirname(__FILE__), '../../lib')
require 'rack/csrf'

Cuba.use Rack::ShowExceptions
Cuba.use Rack::Session::Cookie
Cuba.use Rack::Csrf, :raise => true

require 'app'

run Cuba
