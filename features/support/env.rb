require 'rubygems'
require 'spec/expectations'
require 'rack/test'

$: << File.join(File.dirname(__FILE__), '../../lib')

require 'rack/csrf'
