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
      @skip_list = (opts[:skip] || []).map {|r| /\A#{r}\Z/i}
      @check_only_list = (opts[:check_only] || []).map {|r| /\A#{r}\Z/i}
      @@field = opts[:field] if opts[:field]
      @@key = opts[:key] if opts[:key]

      standard_http_methods = %w(POST PUT DELETE PATCH)
      check_also = opts[:check_also] || []
      @http_methods = (standard_http_methods + check_also).flatten.uniq
    end

    def call(env)
      unless env['rack.session']
        raise SessionUnavailable.new('Rack::Csrf depends on session middleware')
      end
      self.class.token(env)
      req = Rack::Request.new(env)
      untouchable = skip_checking(req) ||
        !@http_methods.include?(req.request_method) ||
        req.params[self.class.field] == env['rack.session'][self.class.key]
      if untouchable
        @app.call(env)
      else
        raise InvalidCsrfToken if @raisable
        [403, {'Content-Type' => 'text/html', 'Content-Length' => '0'}, []]
      end
    end

    def self.key
      @@key
    end

    def self.field
      @@field
    end

    def self.token(env)
      env['rack.session'][key] ||= SecureRandom.base64(32)
    end

    def self.tag(env)
      %Q(<input type="hidden" name="#{field}" value="#{token(env)}" />)
    end

    class << self
      alias_method :csrf_key, :key
      alias_method :csrf_field, :field
      alias_method :csrf_token, :token
      alias_method :csrf_tag, :tag
    end

    protected

    # Return +true+ if the given request appears in the <b>skip list</b> or,
    # when the <b>check only list</b> is not empty (i.e., we are working in
    # the "reverse mode" triggered by the +check_only+ option), it does not
    # appear in the <b>check only list.</b>
    def skip_checking request
      to_be_skipped = any? @skip_list, request
      to_be_checked = any? @check_only_list, request
      to_be_skipped || (!@check_only_list.empty? && !to_be_checked)
    end

    # Returns +true+ when the given list "includes" the request.
    def any? list, request
      pi = request.path_info.empty? ? '/' : request.path_info
      list.any? do |route|
        route =~ (request.request_method + ':' + pi)
      end
    end
  end
end
