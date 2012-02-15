Feature: Customization of the header name

  Background:
    Given a rack with the anti-CSRF middleware and the :header option

  Scenario: GET request with the right CSRF header in custom field
    When it receives a GET request with the right CSRF header
    Then it lets it pass untouched

  Scenario: GET request with the wrong CSRF header in custom field
    When it receives a GET request with the wrong CSRF header
    Then it lets it pass untouched

  Scenario Outline: Handling request with the right CSRF header in custom field
    When it receives a <method> request with the right CSRF header
    Then it lets it pass untouched

    Examples:
      | method |
      | POST   |
      | PUT    |
      | DELETE |
      | PATCH  |

  Scenario Outline: Handling request with the wrong CSRF header in custom field
    When it receives a <method> request with the wrong CSRF header
    Then it responds with 403
    And the response body is empty

    Examples:
      | method |
      | POST   |
      | PUT    |
      | DELETE |
      | PATCH  |
