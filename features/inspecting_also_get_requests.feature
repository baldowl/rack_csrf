Feature: Inspecting also GET requests

  Background:
    Given a rack with the anti-CSRF middleware and the :check_also option
      | method |
      | GET    |

  Scenario: GET request with the right CSRF token
    When it receives a GET request with the right CSRF token
    Then it lets it pass untouched

  Scenario: GET request with the wrong CSRF token
    When it receives a GET request with the wrong CSRF token
    Then it responds with 403
    And the response body is empty

  Scenario: GET request without the CSRF token
    When it receives a GET request without the CSRF token
    Then it responds with 403
    And the response body is empty
