require 'rubygems'
require 'spec/expectations'

$: << File.join(File.dirname(__FILE__), '../../lib')
$: << File.join(File.dirname(__FILE__))

require 'rack/csrf'

require 'fake_session'