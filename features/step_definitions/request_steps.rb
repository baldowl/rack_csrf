# Yes, they're not as DRY as possible, but I think they're more readable than
# a single step definition with a few captures and more complex checkings.

When /^it receives a (.*) request without the CSRF (?:token|header)$/ do |http_method|
  begin
    @browser.request '/', :method => http_method
  rescue StandardError => e
    @exception = e
  end
end

When /^it receives a (.*) request for (.+) without the CSRF (?:token|header|token or header)$/ do |http_method, path|
  begin
    @browser.request path, :method => http_method
  rescue StandardError => e
    @exception = e
  end
end

When /^it receives a (.*) request with the right CSRF token$/ do |http_method|
  @browser.request '/', :method        => http_method,
                        'rack.session' => {Rack::Csrf.key   => 'right_token'},
                        :params        => {Rack::Csrf.field => 'right_token'}
end

When /^it receives a (.*) request with the right CSRF header$/ do |http_method|
  @browser.request '/', :method                     => http_method,
                        'rack.session'              => {Rack::Csrf.key => 'right_token'},
                        Rack::Csrf.rackified_header => 'right_token'
end

When /^it receives a (.*) request with the wrong CSRF token$/ do |http_method|
  begin
    @browser.request '/', :method        => http_method,
                          'rack.session' => {Rack::Csrf.key   => 'right_token'},
                          :params        => {Rack::Csrf.field => 'wrong_token'}
  rescue StandardError => e
    @exception = e
  end
end

When /^it receives a (.*) request with the wrong CSRF header/ do |http_method|
  begin
    @browser.request '/', :method => http_method,
                          Rack::Csrf.rackified_header => 'right_token'
  rescue StandardError => e
    @exception = e
  end
end

When /^it receives a (.*) request with neither PATH_INFO nor CSRF token or header$/ do |http_method|
  begin
    @browser.request '/doesntmatter', :method => http_method, 'PATH_INFO' => ''
  rescue StandardError => e
    @exception = e
  end
end

When /^it receives a request with headers (.+) = ([^ ]+) without the CSRF token or header$/ do |name, value|
  begin
    @browser.request '/', Hash[:method, 'POST', name, value]
  rescue StandardError => e
    @exception = e
  end
end

When /^it receives a request with headers (.+) = ([^,]+), (.+), and without the CSRF token or header$/ do |name, value, method|
  begin
    @browser.request '/', Hash[:method, method, name, value]
  rescue StandardError => e
    @exception = e
  end
end
