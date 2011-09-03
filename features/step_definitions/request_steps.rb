# Yes, they're not as DRY as possible, but I think they're more readable than
# a single step definition with a few captures and more complex checkings.

When /^it receives a (.*) request without the CSRF token$/ do |http_method|
  begin
    @browser.request '/', :method => http_method
  rescue Exception => e
    @exception = e
  end
end

When /^it receives a (.*) request for (.+) without the CSRF token$/ do |http_method, path|
  begin
    @browser.request path, :method => http_method
  rescue Exception => e
    @exception = e
  end
end

When /^it receives a (.*) request with the right CSRF token$/ do |http_method|
  @browser.request '/', :method => http_method,
    'rack.session' => {Rack::Csrf.key => 'right_token'},
    :params => {Rack::Csrf.field => 'right_token'}
end

When /^it receives a (.*) request with the wrong CSRF token$/ do |http_method|
  begin
    @browser.request '/', :method => http_method,
      :params => {Rack::Csrf.field => 'whatever'}
  rescue Exception => e
    @exception = e
  end
end

When /^it receives a (.*) request with neither PATH_INFO nor CSRF token$/ do |http_method|
  begin
    @browser.request '/doesntmatter', :method => http_method, 'PATH_INFO' => ''
  rescue Exception => e
    @exception = e
  end
end
