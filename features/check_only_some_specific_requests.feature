Feature: Check only some specific requests

  Background:
    Given a rack with the anti-CSRF middleware and the :check_only option
      | pair             |
      | POST:/check/this |

  Scenario: Blocking that specific request
    When it receives a POST request for /check/this without the CSRF token
    Then it responds with 403

  Scenario Outline: Not blocking other requests
    When it receives a <method> request for <path> without the CSRF token
    Then it lets it pass untouched

    Examples:
      | method | path         |
      | GET    | /check/this  |
      | PUT    | /check/this  |
      | PATCH  | /check/this  |
      | DELETE | /check/this  |
      | CUSTOM | /check/this  |
      | GET    | /another/one |
      | POST   | /another/one |
      | PUT    | /another/one |
      | PATCH  | /another/one |
      | DELETE | /another/one |
      | CUSTOM | /another/one |
