@search @1-0
Feature: Search

  Scenario: Navigation
    Given I am on the home page
    And I click in the search field
    And I leave the field blank
    When I press enter in the search field
    Then I should see a list of all products available on the site
