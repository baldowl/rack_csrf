require 'sinatra'
require 'rack/csrf'

require 'erb'
require './app'

use Rack::Session::Cookie
use Rack::Csrf

run Sinatra::Application
