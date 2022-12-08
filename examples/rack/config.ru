require 'rack/csrf'
require 'rack/session'

require 'erb'
require './app'

use Rack::Session::Cookie
use Rack::Csrf

run LittleApp
