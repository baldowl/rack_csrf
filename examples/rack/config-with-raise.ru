require 'rack/csrf'

require 'erb'
require './app'

use Rack::ShowExceptions
use Rack::Session::Cookie
use Rack::Csrf, :raise => true

run LittleApp
