@checkout @cart
Feature:  Checkout
 Acceptance Criteria:

Background:  Setup
  Given THIS IS A MANUAL TEST THAT WON'T BE AUTOMATED

Scenario: Verify Empty Cart
  Given I am on the home page
  And I am on the admin data expiration page
  When I click on delete open clusters
  Then I should see "Never" on the page
