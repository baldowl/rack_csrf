require 'rack'
require 'webrick/utils'

module Rack
  class Csrf
    class SessionUnavailable < StandardError; end

    def initialize(app)
      @app = app
    end

    def call(env)
      unless env['rack.session']
        raise SessionUnavailable.new('Rack::Csrf depends on session middleware')
      end
      req = Rack::Request.new(env)
      if %w(POST PUT DELETE).include?(req.request_method) && req.POST[self.class.csrf_field] != env['rack.session']['rack.csrf']
        [417, {'Content-Type' => 'text/html', 'Content-Length' => '0'}, []]
      else
        @app.call(env)
      end
    end

    def self.csrf_field
      '_csrf'
    end

    def self.csrf_token(env)
      env['rack.session']['rack.csrf'] ||= WEBrick::Utils.random_string(32)
    end

    def self.csrf_tag(env)
      %Q(<input type="hidden" name="#{csrf_field}" value="#{csrf_token(env)}" />)
    end
  end
end
