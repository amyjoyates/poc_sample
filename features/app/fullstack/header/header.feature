@header
Feature:  Header
  Acceptance Criteria:

  Background:  Setup
    Given THIS IS A MANUAL TEST THAT WON'T BE AUTOMATED

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
