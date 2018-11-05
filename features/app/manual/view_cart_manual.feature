@checkout @cart
Feature:  Checkout
 Acceptance Criteria:

 Background: Manual Test - speeds up test run
   Given THIS IS A MANUAL TEST

  @happy-path
  Scenario: Verify Checkout with one item
    And I am on the home page
    When I add the "Magic Mouse" product in my cart
    Then I should see "1 item | Checkout" on the page
    When I click on the checkout link
    Then I should see "Checkout" on the page
    And I click continue
    When I see the info Page
    Then I should select a shipping price
    And I should be able to enter correct billing account information
    When I click Purchase
    Then I should see a successful order
