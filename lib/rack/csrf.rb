require 'rack'
require 'securerandom'

module Rack
  class Csrf
    class SessionUnavailable < StandardError; end
    class InvalidCsrfToken < StandardError; end

    @@field  = '_csrf'
    @@header = 'X_CSRF_TOKEN'
    @@key    = 'csrf.token'

    def initialize(app, opts = {})
      @app = app

      @raisable        = opts[:raise] || false
      @skip_list       = (opts[:skip] || []).map {|r| /\A#{r}\Z/i}
      @skip_if         = opts[:skip_if] if opts[:skip_if]
      @check_only_list = (opts[:check_only] || []).map {|r| /\A#{r}\Z/i}
      @lazy            = opts[:lazy] || false
      @@field          = opts[:field] if opts[:field]
      @@header         = opts[:header] if opts[:header]
      @@key            = opts[:key] if opts[:key]

      standard_http_methods = %w(POST PUT DELETE PATCH)
      check_also            = opts[:check_also] || []
      @http_methods = (standard_http_methods + check_also).flatten.uniq
    end

    def call(env)
      unless env['rack.session']
        raise SessionUnavailable.new('Rack::Csrf depends on session middleware')
      end
      self.class.token(env) unless @lazy
      req = Rack::Request.new(env)
      untouchable = skip_checking(req) ||
        !@http_methods.include?(req.request_method) ||
        lazily_prefill_session(env) ||
        req.params[self.class.field] == env['rack.session'][self.class.key] ||
        req.env[self.class.rackified_header] == env['rack.session'][self.class.key]
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

    def self.header
      @@header
    end

    def self.token(env)
      env['rack.session'][key] ||= SecureRandom.base64(32)
    end

    def self.tag(env)
      %Q(<input type="hidden" name="#{field}" value="#{token(env)}" />)
    end

    def self.metatag(env, options = {})
      name = options.delete(:name) || '_csrf'
      %Q(<meta name="#{name}" content="#{token(env)}" />)
    end

    class << self
      alias_method :csrf_key, :key
      alias_method :csrf_field, :field
      alias_method :csrf_header, :header
      alias_method :csrf_token, :token
      alias_method :csrf_tag, :tag
      alias_method :csrf_metatag, :metatag
    end

    protected

    # Returns the custom header's name adapted to current standards.
    def self.rackified_header
      "HTTP_#{@@header.gsub('-','_').upcase}"
    end

    # Returns +true+ if the given request appears in the <b>skip list</b> or
    # the <b>conditional skipping code</b> return true or, when the <b>check
    # only list</b> is not empty (i.e., we are working in the "reverse mode"
    # triggered by the +check_only+ option), it does not appear in the
    # <b>check only list.</b>
    def skip_checking request
      to_be_skipped = any? @skip_list, request
      to_be_skipped ||= @skip_if && @skip_if.call(request)
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

    # Adds the CSRF token to our session if it's not already there.
    #
    # It must return false.
    def lazily_prefill_session env
      self.class.token(env) && false
    end
  end
end
