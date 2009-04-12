Feature: Setup of the middleware

  As a developer
  I want to insert the middleware into the rack
  So that I can use the anti-CSRF functionality

  Scenario: Simple setup with session support
    Given a Rack setup with the session middleware
    When I insert the anti-CSRF middleware into the rack
    Then I get a fully functional rack

  Scenario: Simple setup without session support
    Given a Rack setup without the session middleware
    When I insert the anti-CSRF middleware into the rack
    Then I get an error message
