@checkout @cart
Feature:  Checkout
 Acceptance Criteria:

Background: Not Automated yet
  Given THIS IS CURRENTLY NOT AUTOMATED BUT WILL BE
  Given I am not logged in and have nothing in my cart

  @happy-path
  Scenario: Verify Checkout with one item
    And I am on the home page
    When I add the "Magic Mouse" product in my cart
    Then I should see "1 item | Checkout" on the page
    When I click on the checkout link
    Then I should see "Checkout" on the page

  Scenario: Verify Empty Cart
    And I am on the home page
    When I click on the 0 item/cart link in the header
    Then I should see "Oops, there is nothing in your cart" on the page

  Scenario: Verify Checkout process uses a secure connection
    And I am on the home page
    When I click on the 0 item/cart link in the header
    Then I should see that we are using a secure connection
