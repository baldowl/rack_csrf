Feature: Customization of the key name

  Background:
    Given a rack with the anti-CSRF middleware and the :key option

  Scenario: GET request with the right CSRF token stored in custom key
    When it receives a GET request with the right CSRF token
    Then it lets it pass untouched

  Scenario: GET request with the wrong CSRF token stored in custom key
    When it receives a GET request with the wrong CSRF token
    Then it lets it pass untouched

  Scenario Outline: Handling request with the right CSRF token stored in custom key
    When it receives a <method> request with the right CSRF token
    Then it lets it pass untouched

    Examples:
      | method |
      | POST   |
      | PUT    |
      | DELETE |
      | PATCH  |

  Scenario Outline: Handling request with the wrong CSRF token stored in custom key
    When it receives a <method> request with the wrong CSRF token
    Then it responds with 403
    And the response body is empty

    Examples:
      | method |
      | POST   |
      | PUT    |
      | DELETE |
      | PATCH  |
