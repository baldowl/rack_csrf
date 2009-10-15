Feature: Filtering only browser generated requests

  Scenario Outline: Handling request without CSRF token
    Given a rack with the anti-CSRF middleware and the :browser_only option
    When it receives a <method> request without the CSRF token
    Then it lets it pass untouched

    Examples:
      | method |
      | POST   |
      | PUT    |
      | DELETE |

  Scenario Outline: Handling request without CSRF token
    Given a rack with the anti-CSRF middleware and the :browser_only option
    When it receives a <method> request without the CSRF token from a browser
    Then it responds with 403
    And the response body is empty

    Examples:
      | method |
      | POST   |
      | PUT    |
      | DELETE |
