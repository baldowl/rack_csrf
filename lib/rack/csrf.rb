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
    @@key = 'csrf.token'

    def initialize(app, opts = {})
      @app = app

      @raisable = opts[:raise] || false
      @skippable = (opts[:skip] || []).map {|r| /\A#{r}\Z/i}
      @@field = opts[:field] if opts[:field]
      @@key = opts[:key] if opts[:key]

      @http_verbs = %w(POST PUT DELETE PATCH)
    end

    def call(env)
      unless env['rack.session']
        raise SessionUnavailable.new('Rack::Csrf depends on session middleware')
      end
      self.class.csrf_token(env)
      req = Rack::Request.new(env)
      untouchable = !@http_verbs.include?(req.request_method) ||
        req.POST[self.class.csrf_field] == env['rack.session'][self.class.csrf_key] ||
        skip_checking(req)
      if untouchable
        @app.call(env)
      else
        raise InvalidCsrfToken if @raisable
        [403, {'Content-Type' => 'text/html', 'Content-Length' => '0'}, []]
      end
    end

    def self.csrf_key
      @@key
    end

    def self.csrf_field
      @@field
    end

    def self.csrf_token(env)
      env['rack.session'][csrf_key] ||= SecureRandom.base64(32)
    end

    def self.csrf_tag(env)
      %Q(<input type="hidden" name="#{csrf_field}" value="#{csrf_token(env)}" />)
    end

    protected

    def skip_checking request
      @skippable.any? do |route|
        route =~ (request.request_method + ':' + request.path_info)
      end
    end
  end
end
