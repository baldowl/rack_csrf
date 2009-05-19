require 'sinatra'
require File.dirname(__FILE__) + '/../lib/rack/csrf'

require 'erb'
require 'app'

use Rack::Session::Cookie
use Rack::Csrf

set :app_file, 'app.rb'

run Sinatra::Application
