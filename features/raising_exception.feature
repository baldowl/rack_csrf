Feature: Handling of the HTTP requests raising an exception

  Scenario: GET request without CSRF token
    Given a Rack setup with the anti-CSRF middleware and the :raise option
    When it receives a GET request without the CSRF token
    Then it lets it pass untouched

  Scenario Outline: Handling request without CSRF token
    Given a Rack setup with the anti-CSRF middleware and the :raise option
    When it receives a <method> request without the CSRF token
    Then there is no response
    And an exception is climbing up the stack

    Examples:
      | method |
      | POST   |
      | PUT    |
      | DELETE |

  Scenario Outline: Handling request with the right CSRF token
    Given a Rack setup with the anti-CSRF middleware and the :raise option
    When it receives a <method> request with the right CSRF token
    Then it lets it pass untouched

    Examples:
      | method |
      | POST   |
      | PUT    |
      | DELETE |

  Scenario Outline: Handling request with the wrong CSRF token
    Given a Rack setup with the anti-CSRF middleware and the :raise option
    When it receives a <method> request with the wrong CSRF token
    Then there is no response
    And an exception is climbing up the stack

    Examples:
      | method |
      | POST   |
      | PUT    |
      | DELETE |
