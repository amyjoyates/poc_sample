@search
Feature: Search
  Acceptance Criteria:

  @happy-path
  Scenario: Verify Search of Known Product
    Given I am on the home page
    And I enter "Magic Mouse" into the search page
    When I press the enter key
    Then I should see "Magic Mouse" on the page
    And I should see "$150.00" on the page
