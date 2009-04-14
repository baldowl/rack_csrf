When /^it receives a GET request (with|without) the CSRF token$/ do |prep|
  if prep == 'with'
    url = "/?#{Rack::Utils.build_query(Rack::Csrf.csrf_field => 'whatever')}"
  else
    url = '/'
  end
  @response = Rack::MockRequest.new(@app).get(url)
end

When /^it receives a (POST|PUT|DELETE) request without the CSRF token$/ do |http_method|
  http_method.downcase!
  begin
    @response = Rack::MockRequest.new(@app).send http_method.to_sym, '/'
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

Then /^it lets it pass untouched$/ do
  @response.should be_ok
  @response.should =~ /Hello world!/
end

Then /^it responds with 417$/ do
  @response.status.should == 417
end

Then /^the response body is empty$/ do
  @response.body.should be_empty
end

Then /^there is no response$/ do
  @response.should be_nil
end

Then /^an exception is climbing up the stack$/ do
  @exception.should_not be_nil
  @exception.should be_an_instance_of(Rack::Csrf::InvalidCsrfToken)
end
