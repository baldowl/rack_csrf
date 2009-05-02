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

    @@field = '_csrf'

    def initialize(app, opts = {})
      @app = app
      @raisable = opts[:raise] || false
      @skippable = opts[:skip] || []
      @skippable.map {|s| s.downcase!}
      @@field = opts[:field] if opts[:field]
    end

    def call(env)
      unless env['rack.session']
        raise SessionUnavailable.new('Rack::Csrf depends on session middleware')
      end
      self.class.csrf_token(env)
      req = Rack::Request.new(env)
      untouchable = !%w(POST PUT DELETE).include?(req.request_method) ||
        req.POST[self.class.csrf_field] == env['rack.session']['csrf.token'] ||
        skip_checking(req)
      if untouchable
        @app.call(env)
      else
        raise InvalidCsrfToken if @raisable
        [417, {'Content-Type' => 'text/html', 'Content-Length' => '0'}, []]
      end
    end

    def self.csrf_field
      @@field
    end

    def self.csrf_token(env)
      env['rack.session']['csrf.token'] ||= SecureRandom.base64(32)
    end

    def self.csrf_tag(env)
      %Q(<input type="hidden" name="#{csrf_field}" value="#{csrf_token(env)}" />)
    end

    protected

    def skip_checking request
      @skippable.include?(request.request_method.downcase + ':' + request.path_info)
    end
  end
end
