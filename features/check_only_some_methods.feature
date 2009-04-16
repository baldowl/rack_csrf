Feature: Checking only some HTTP methods

  Scenario Outline: Checking only <check> requests without CSRF token
    Given a Rack setup with the anti-CSRF middleware and the :methods option
      | checkable |
      | <check>   |
    When it receives a <method> request without the CSRF token
    Then it lets it pass untouched

    Examples:
      | check    | method  |
      | POST     | GET     |
      | POST     | PUT     |
      | POST     | DELETE  |
      | PUT      | GET     |
      | PUT      | POST    |
      | PUT      | DELETE  |
      | DELETE   | GET     |
      | DELETE   | POST    |
      | DELETE   | PUT     |

  Scenario Outline: Checking only <check> requests with wrong CSRF token
    Given a Rack setup with the anti-CSRF middleware and the :methods option
      | checkable |
      | <check>   |
    When it receives a <method> request with the wrong CSRF token
    Then it lets it pass untouched

    Examples:
      | check    | method  |
      | POST     | PUT     |
      | POST     | DELETE  |
      | PUT      | POST    |
      | PUT      | DELETE  |
      | DELETE   | POST    |
      | DELETE   | PUT     |
