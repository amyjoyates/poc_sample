@header @1-0
Feature:  Header
  Acceptance Criteria:

  Scenario: Verify that the Tools logo navigates you from checkout to home
    And I navigate to the checkout page
    When I click on the Tools logo
    Then I should be navigating to the main home page

  Scenario: Verify that the Tools logo navigates you from my account to home
    And I navigate to the my account page
    When I click on the Tools logo
    Then I should be navigating to the main home page

  Scenario: Verify that the Tools logo navigates you from my account to home
    And I navigate to the my account page
    When I click on the Tools logo
    Then I should be navigating to the main home page
