Feature: Setup of the middleware

  Scenario: Simple setup with session support
    Given a rack with the session middleware
    When I insert the anti-CSRF middleware
    Then I get a fully functional rack

  Scenario: Simple setup without session support
    Given a rack without the session middleware
    When I insert the anti-CSRF middleware
    Then I get an error message

  Scenario: Setup with :raise option
    Given a rack with the session middleware
    When I insert the anti-CSRF middleware with the :raise option
    Then I get a fully functional rack

  Scenario: Setup with the :skip option
    Given a rack with the session middleware
    When I insert the anti-CSRF middleware with the :skip option
      | route              |
      | POST:/not_checking |
      | PUT:/is_wrong      |
    Then I get a fully functional rack

  Scenario: Setup with the :field option
    Given a rack with the session middleware
    When I insert the anti-CSRF middleware with the :field option
    Then I get a fully functional rack

  Scenario: Setup with the :key option
    Given a rack with the session middleware
    When I insert the anti-CSRF middleware with the :key option
    Then I get a fully functional rack

  Scenario: Setup with the :check_also option
    Given a rack with the session middleware
    When I insert the anti-CSRF middleware with the :check_also option
      | method |
      | ME     |
      | YOU    |
    Then I get a fully functional rack

  Scenario: Setup with the :check_only option
    Given a rack with the session middleware
    When I insert the anti-CSRF middleware with the :check_only option
      | route               |
      | POST:/check/me      |
      | PUT:/check/this/too |
    Then I get a fully functional rack
