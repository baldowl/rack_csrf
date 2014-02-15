require 'rack/csrf'

require 'erb'
require './app'

use Rack::Session::Cookie
use Rack::Csrf

run LittleApp
