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
      @skippable = (opts[:skip] || []).map {|r| /\A#{r}\Z/i}
      @@field = opts[:field] if opts[:field]
      @browser_only = opts[:browser_only] || false

      @http_verbs = %w(POST PUT DELETE)
      @browser_content_types = ['text/html', 'application/xhtml+xml', 'xhtml',
        'application/x-www-form-urlencoded',
        'multipart/form-data',
        'text/plain', 'txt']
    end

    def call(env)
      unless env['rack.session']
        raise SessionUnavailable.new('Rack::Csrf depends on session middleware')
      end
      self.class.csrf_token(env)
      req = Rack::Request.new(env)
      untouchable = !@http_verbs.include?(req.request_method) ||
        req.POST[self.class.csrf_field] == env['rack.session']['csrf.token'] ||
        skip_checking(req) || (@browser_only && !from_a_browser(req))
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
      @skippable.any? do |route|
        route =~ (request.request_method + ':' + request.path_info)
      end
    end

    def from_a_browser request
      @browser_content_types.include?(request.media_type)
    end
  end
end
