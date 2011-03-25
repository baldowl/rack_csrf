Feature: Handling of the HTTP requests returning an empty response

  Scenario: GET request with CSRF token
    Given a rack with the anti-CSRF middleware
    When it receives a GET request with the CSRF token
    Then it lets it pass untouched

  Scenario: GET request without CSRF token
    Given a rack with the anti-CSRF middleware
    When it receives a GET request without the CSRF token
    Then it lets it pass untouched

  Scenario Outline: Handling request without CSRF token
    Given a rack with the anti-CSRF middleware
    When it receives a <method> request without the CSRF token
    Then it responds with 403
    And the response body is empty

    Examples:
      | method |
      | POST   |
      | PUT    |
      | DELETE |
      | PATCH  |

  Scenario Outline: Handling request with the right CSRF token
    Given a rack with the anti-CSRF middleware
    When it receives a <method> request with the right CSRF token
    Then it lets it pass untouched

    Examples:
      | method |
      | POST   |
      | PUT    |
      | DELETE |
      | PATCH  |

  Scenario Outline: Handling request with the wrong CSRF token
    Given a rack with the anti-CSRF middleware
    When it receives a <method> request with the wrong CSRF token
    Then it responds with 403
    And the response body is empty

    Examples:
      | method |
      | POST   |
      | PUT    |
      | DELETE |
      | PATCH  |
