Feature: Lazy pre-filling session with the CSRF token

  Background:
    Given a rack with the anti-CSRF middleware and the :lazy option

  @wip @broken
  Scenario Outline: A safe request does not generate a token
    When it receives a <method> request without the CSRF token
    Then it lets it pass untouched
    And the session does not contain any token

    Examples:
      | method |
      | GET    |
      | HEAD   |
      | OPTION |
      | TRACE  |

  Scenario Outline: A non-safe request does generate a token
    When it receives a <method> request without the CSRF token
    Then the response body is empty
    And the session does contain a token

    Examples:
      | method |
      | POST   |
      | PUT    |
      | DELETE |
      | PATCH  |
