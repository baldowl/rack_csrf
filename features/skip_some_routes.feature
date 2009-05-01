Feature: Skipping the check for some specific routes

  Scenario Outline: Skipping the check for some requests
    Given a Rack setup with the anti-CSRF middleware and the :skip option
      | pair               |
      | POST:/not_checking |
      | PUT:/is_wrong      |
    When it receives a <method> request for <path> without the CSRF token
    Then it lets it pass untouched

    Examples:
      | method | path          |
      | POST   | /not_checking |
      | PUT    | /is_wrong     |

  Scenario Outline: Keep checking the requests for other method/path pairs
    Given a Rack setup with the anti-CSRF middleware and the :skip option
      | pair               |
      | POST:/not_checking |
      | PUT:/is_wrong      |
    When it receives a <method> request for <path> without the CSRF token
    Then it responds with 417
    And the response body is empty

    Examples:
      | method | path          |
      | PUT    | /not_checking |
      | DELETE | /not_checking |
      | POST   | /is_wrong     |
      | DELETE | /is_wrong     |
      | POST   | /             |
      | PUT    | /not          |
      | POST   | /is           |
