Feature: Customization of the field name

  Scenario: GET request with CSRF token in custom field
    Given a rack with the anti-CSRF middleware and the :field option
    When it receives a GET request with the CSRF token
    Then it lets it pass untouched

  Scenario Outline: Handling request with the right CSRF token in custom field
    Given a rack with the anti-CSRF middleware and the :field option
    When it receives a <method> request with the right CSRF token
    Then it lets it pass untouched

    Examples:
      | method |
      | POST   |
      | PUT    |
      | DELETE |

  Scenario Outline: Handling request with the wrong CSRF token in custom field
    Given a rack with the anti-CSRF middleware and the :field option
    When it receives a <method> request with the wrong CSRF token
    Then it responds with 403
    And the response body is empty

    Examples:
      | method |
      | POST   |
      | PUT    |
      | DELETE |
