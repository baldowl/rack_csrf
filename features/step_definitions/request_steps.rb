When /^it receives a GET request (with|without) the CSRF token$/ do |prep|
  if prep == 'with'
    url = "/?#{Rack::Utils.build_query(Rack::Csrf.csrf_field => 'whatever')}"
  else
    url = '/'
  end
  @response = Rack::MockRequest.new(@app).get(url)
end

# Yes, they're not as DRY as possible, but I think they're more readable than
# a single step definition with a few captures and more complex checkings.

When /^it receives a (POST|PUT|DELETE) request without the CSRF token$/ do |http_method|
  http_method.downcase!
  begin
    @response = Rack::MockRequest.new(@app).send http_method.to_sym, '/'
  rescue Exception => e
    @exception = e
  end
end

When /^it receives a (POST|PUT|DELETE) request for (.+) without the CSRF token$/ do |http_method, path|
  http_method.downcase!
  begin
    @response = Rack::MockRequest.new(@app).send http_method.to_sym, path
  rescue Exception => e
    @exception = e
  end
end

When /^it receives a (POST|PUT|DELETE) request with the right CSRF token$/ do |http_method|
  http_method.downcase!
  @response = Rack::MockRequest.new(@app).send http_method.to_sym, '/',
    :input => "#{Rack::Csrf.csrf_field}=right_token"
end

When /^it receives a (POST|PUT|DELETE) request with the wrong CSRF token$/ do |http_method|
  http_method.downcase!
  begin
    @response = Rack::MockRequest.new(@app).send http_method.to_sym, '/',
      :input => "#{Rack::Csrf.csrf_field}=whatever"
  rescue Exception => e
    @exception = e
  end
end
