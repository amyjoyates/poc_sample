@checkout @cart @1-0
Feature:  Checkout
 Acceptance Criteria:

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

Scenario: Verify Empty Cart
Scenario: Verify Max items in Cart
Scenario: Verify updating quantity in the cart
Scenario: Verify that customers cannot purchase more products then what is in stock
Scenario: Verify max number of a single product is allowed to be purchased
Scenario: Verify max price that should be seen on the page
Scenario: Verify removing products from cart
Scenario: Verify changing number of products to 0 - should see product removed from cart
Scenario: Verify that the product and price are correct in the cart
