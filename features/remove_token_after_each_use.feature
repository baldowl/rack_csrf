Feature: Remove CSRF token after each use

  Scenario: The CSRF token is normally unchanged after use
    Given a rack with the anti-CSRF middleware
    When it receives a POST request with the right CSRF token
    Then it lets it pass untouched
    And the CSRF token is still there

  Scenario: The CSRF token is not changed if requests don't need a check
    Given a rack with the anti-CSRF middleware and the :remove_token option
    When it receives a GET request with the right CSRF token
    Then it lets it pass untouched
    And the CSRF token is still there

  Scenario: The CSRF token is deleted after use
    Given a rack with the anti-CSRF middleware and the :remove_token option
    When it receives a POST request with the right CSRF token
    Then it lets it pass untouched
    But the CSRF token has been deleted
