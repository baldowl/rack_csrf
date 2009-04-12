Feature: Handling of the HTTP requests

  As a developer
  I want to use the anti-CSRF middleware
  So that I can protect my web application

  Scenario: GET request with CSRF token
    Given a Rack setup with the anti-CSRF middleware
    When it receives a GET request with the CSRF token
    Then it lets it pass untouched

  Scenario: GET request without CSRF token
    Given a Rack setup with the anti-CSRF middleware
    When it receives a GET request without the CSRF token
    Then it lets it pass untouched

  Scenario Outline: Handling request without CSRF token
    Given a Rack setup with the anti-CSRF middleware
    When it receives a <method> request without the CSRF token
    Then it responds with 417
    And the response body is empty

    Examples:
      | method |
      | POST   |
      | PUT    |
      | DELETE |

  Scenario Outline: Handling request with the right CSRF token
    Given a Rack setup with the anti-CSRF middleware
    When it receives a <method> request with the right CSRF token
    Then it lets it pass untouched

    Examples:
      | method |
      | POST   |
      | PUT    |
      | DELETE |

  Scenario Outline: Handling request with the wrong CSRF token
    Given a Rack setup with the anti-CSRF middleware
    When it receives a <method> request with the wrong CSRF token
    Then it responds with 417
    And the response body is empty

    Examples:
      | method |
      | POST   |
      | PUT    |
      | DELETE |
