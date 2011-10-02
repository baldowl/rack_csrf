require 'cuba'
$: << File.join(File.dirname(__FILE__), '../../lib')
require 'rack/csrf'

Cuba.use Rack::Session::Cookie
Cuba.use Rack::Csrf

require 'app'

run Cuba
