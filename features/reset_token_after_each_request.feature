Feature: Reset CSRF token after each request

  Scenario: Requesting the same form twice returns different tokens
    Given a rack with the anti-CSRF middleware and the :reset_token option
    When I request a page with a form
    Then it contains a CSRF token
    When I request the same page again
    Then it contains a different CSRF token
