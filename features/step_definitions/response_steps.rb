Then /^it lets it pass untouched$/ do
  expect(@browser.last_response).to be_ok
  expect(@browser.last_response).to match(/Hello world!/)
end

Then /^it responds with (\d\d\d)$/ do |code|
  expect(@browser.last_response.status).to eq(code.to_i)
end

Then /^the response body is empty$/ do
  expect(@browser.last_response.body).to be_empty
end

Then /^there is no response$/ do
  expect {@browser.last_response}.to raise_exception(Rack::Test::Error)
end

Then /^an exception is climbing up the stack$/ do
  expect(@exception).to be_an_instance_of(Rack::Csrf::InvalidCsrfToken)
end
