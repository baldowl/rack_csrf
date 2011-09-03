Feature: Handling custom HTTP methods

  Background:
    Given a rack with the anti-CSRF middleware and the :check_also option
      | method |
      | ME     |
      | YOU    |

  Scenario Outline: Blocking "standard" requests without the token
    When it receives a <method> request without the CSRF token
    Then it responds with 403
    And the response body is empty

    Examples:
      | method |
      | POST   |
      | PUT    |
      | DELETE |
      | PATCH  |

  Scenario Outline: Blocking "standard" requests with the wrong token
    When it receives a <method> request with the wrong CSRF token
    Then it responds with 403
    And the response body is empty

    Examples:
      | method |
      | POST   |
      | PUT    |
      | DELETE |
      | PATCH  |

  Scenario Outline: Blocking requests without the token
    When it receives a <method> request without the CSRF token
    Then it responds with 403
    And the response body is empty

    Examples:
      | method |
      | ME     |
      | YOU    |

  Scenario Outline: Blocking requests with the wrong token
    When it receives a <method> request with the wrong CSRF token
    Then it responds with 403
    And the response body is empty

    Examples:
      | method |
      | ME     |
      | YOU    |

  Scenario Outline: Letting pass "unknown" and safe requests without the token
    When it receives a <method> request without the CSRF token
    Then it lets it pass untouched

    Examples:
      | method  |
      | HIM     |
      | HER     |
      | GET     |
      | OPTIONS |
