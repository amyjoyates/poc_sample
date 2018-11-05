@software-delivery @manual
Feature:  Update Software
  Acceptance Criteria:
    This test is to make sure that we are able to update the existing website to the new code

  Background: Manual Test - speeds up test run
    Given THIS IS A MANUAL TEST

  Scenario: Verify update of website code
    Given that I have new code to Update
    And I spin up a new website with version 1.0
    When I update to version 1.1
    Then I should see the changes on the website
