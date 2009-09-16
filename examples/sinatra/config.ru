require 'sinatra'
$: << File.join(File.dirname(__FILE__), '../../lib')
require 'rack/csrf'

require 'erb'
require 'app'

use Rack::Session::Cookie
use Rack::Csrf

set :app_file, 'app.rb'

run Sinatra::Application
