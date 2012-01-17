Feature: Skipping the check if a block passes

  Scenario Outline: Skipping check for requests with specific header
    Given a rack with the anti-CSRF middleware and the :skip_if option
      | name        | value   |
      | token       | skip    |
      | User-Agent  | MSIE    |
    When it receives a request with headers <name> = <value> without the CSRF token
    Then it lets it pass untouched
    
    Examples:
      | name        | value   |
      | token       | skip    |
      | User-Agent  | MSIE    |
    
    