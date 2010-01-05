When /^it receives a GET request (with|without) the CSRF token$/ do |prep|
  params = prep == 'with' ? {Rack::Csrf.csrf_field => 'whatever'} : {}
  @browser.get '/', :params => params
end

# Yes, they're not as DRY as possible, but I think they're more readable than
# a single step definition with a few captures and more complex checkings.

When /^it receives a (POST|PUT|DELETE) request without the CSRF token$/ do |http_method|
  begin
    @browser.request '/', :method => http_method
  rescue Exception => e
    @exception = e
  end
end

When /^it receives a (POST|PUT|DELETE) request for (.+) without the CSRF token$/ do |http_method, path|
  begin
    @browser.request path, :method => http_method
  rescue Exception => e
    @exception = e
  end
end

When /^it receives a (POST|PUT|DELETE) request with the right CSRF token$/ do |http_method|
  @browser.request '/', :method => http_method,
    'rack.session' => {'csrf.token' => 'right_token'},
    :params => {Rack::Csrf.csrf_field => 'right_token'}
end

When /^it receives a (POST|PUT|DELETE) request with the wrong CSRF token$/ do |http_method|
  begin
    @browser.request '/', :method => http_method,
      :params => {Rack::Csrf.csrf_field => 'whatever'}
  rescue Exception => e
    @exception = e
  end
end
