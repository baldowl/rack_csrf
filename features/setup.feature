Feature: Setup of the middleware

  Scenario: Simple setup with session support
    Given a Rack setup with the session middleware
    When I insert the anti-CSRF middleware
    Then I get a fully functional rack

  Scenario: Simple setup without session support
    Given a Rack setup without the session middleware
    When I insert the anti-CSRF middleware
    Then I get an error message

  Scenario: Setup with :raise option
    Given a Rack setup with the session middleware
    When I insert the anti-CSRF middleware with the :raise option
    Then I get a fully functional rack

  Scenario: Setup with the :skip option
    Given a Rack setup with the session middleware
    When I insert the anti-CSRF middleware with the :skip option
      | route              |
      | POST:/not_checking |
      | PUT:/is_wrong      |
    Then I get a fully functional rack
