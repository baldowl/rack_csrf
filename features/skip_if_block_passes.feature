Feature: Skipping the check if a block passes

  Scenario Outline: Skipping check for requests with specific header
    Given a rack with the anti-CSRF middleware and the :skip_if option
      | name        | value   |
      | token       | skip    |
      | User-Agent  | MSIE    |
    When it receives a request with headers <name> = <value> without the CSRF token or header
    Then it lets it pass untouched

    Examples:
      | name        | value   |
      | token       | skip    |
      | User-Agent  | MSIE    |

  Scenario Outline: Not skipping check for requests without specific header
    Given a rack with the anti-CSRF middleware and the :skip_if option
      | name        | value   |
      | token       | skip    |
      | User-Agent  | MSIE    |
    When it receives a request with headers <name> = <value> without the CSRF token or header
    Then it responds with 403

    Examples:
      | name        | value   |
      | token       | forward |
      | User-Agent  | WebKit  |
      | User-Agent  | Mozilla |

  Scenario Outline: Skipping check for requests with :skip and :skip_if options
    Given a rack with the anti-CSRF middleware and both the :skip and :skip_if options
      | name        | value   | path    |
      | token       | skip    | POST:/  |
    When it receives a request with headers <name> = <value>, <method>, and without the CSRF token or header
    Then it lets it pass untouched

    Examples:
      | name        | value   | method  |
      | token       | skip    | POST    |
      | token       | pass    | POST    |
