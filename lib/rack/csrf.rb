require 'rack'
begin
  require 'securerandom'
rescue LoadError
  require File.dirname(__FILE__) + '/vendor/securerandom'
end

module Rack
  class Csrf
    class SessionUnavailable < StandardError; end
    class InvalidCsrfToken < StandardError; end

    def initialize(app, opts = {})
      @app = app
      @raisable = opts[:raise] || false
    end

    def call(env)
      unless env['rack.session']
        raise SessionUnavailable.new('Rack::Csrf depends on session middleware')
      end
      req = Rack::Request.new(env)
      untouchable = !%w(POST PUT DELETE).include?(req.request_method) ||
        req.POST[self.class.csrf_field] == env['rack.session']['rack.csrf']
      if untouchable
        @app.call(env)
      else
        raise InvalidCsrfToken if @raisable
        [417, {'Content-Type' => 'text/html', 'Content-Length' => '0'}, []]
      end
    end

    def self.csrf_field
      '_csrf'
    end

    def self.csrf_token(env)
      env['rack.session']['rack.csrf'] ||= SecureRandom.base64(32)
    end

    def self.csrf_tag(env)
      %Q(<input type="hidden" name="#{csrf_field}" value="#{csrf_token(env)}" />)
    end
  end
end
