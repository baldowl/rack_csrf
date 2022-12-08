require 'sinatra'
require 'rack/csrf'

require 'erb'
require './app'

use Sinatra::ShowExceptions
use Rack::Session::Cookie
use Rack::Csrf, :raise => true

run Sinatra::Application
