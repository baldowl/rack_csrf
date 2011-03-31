Feature: Skipping the check for some specific routes

  Scenario Outline: Skipping the check for some requests
    Given a rack with the anti-CSRF middleware and the :skip option
      | pair                 |
      | POST:/not_checking   |
      | PUT:/is_wrong        |
      | POST:/not_.*\.json   |
      | DELETE:/cars/.*\.xml |
      | PATCH:/this/one/too  |
    When it receives a <method> request for <path> without the CSRF token
    Then it lets it pass untouched

    Examples:
      | method | path                            |
      | POST   | /not_checking                   |
      | PUT    | /is_wrong                       |
      | POST   | /not_checking.json              |
      | POST   | /not_again/params/whatever.json |
      | DELETE | /cars/abc123.xml                |
      | PATCH  | /this/one/too                   |

  Scenario Outline: Keep checking the requests for other method/path pairs
    Given a rack with the anti-CSRF middleware and the :skip option
      | pair                 |
      | POST:/not_checking   |
      | PUT:/is_wrong        |
      | POST:/not_.*\.json   |
      | DELETE:/cars/.*\.xml |
      | PATCH:/this/one/too  |
    When it receives a <method> request for <path> without the CSRF token
    Then it responds with 403
    And the response body is empty

    Examples:
      | method | path                            |
      | PUT    | /not_checking                   |
      | DELETE | /not_checking                   |
      | PATCH  | /not_checking                   |
      | POST   | /is_wrong                       |
      | DELETE | /is_wrong                       |
      | PATCH  | /is_wrong                       |
      | POST   | /                               |
      | PUT    | /not                            |
      | POST   | /is                             |
      | PUT    | /not_checking.json              |
      | DELETE | /not_checking.json              |
      | PATCH  | /not_checking.json              |
      | PUT    | /not_again/params/whatever.json |
      | DELETE | /not_again/params/whatever.json |
      | PATCH  | /not_again/params/whatever.json |
      | POST   | /cars/abc123.xml                |
      | PUT    | /cars/abc123.xml                |
      | PATCH  | /cars/abc123.xml                |
      | POST   | /this/one/too                   |
      | PUT    | /this/one/too                   |
      | DELETE | /this/one/too                   |

  Scenario Outline: Handling correctly empty PATH_INFO
    Given a rack with the anti-CSRF middleware and the :skip option
      | pair     |
      | POST:/   |
      | PUT:/    |
      | DELETE:/ |
      | PATCH:/  |
    When it receives a <method> request with neither PATH_INFO nor CSRF token
    Then it lets it pass untouched

    Examples:
      | method |
      | POST   |
      | PUT    |
      | DELETE |
      | PATCH  |
