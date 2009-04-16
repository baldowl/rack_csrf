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
