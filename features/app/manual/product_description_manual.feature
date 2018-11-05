@product-description
Feature:  Product Description Tests
  Acceptance Criteria:

  Background: Manual Test - speeds up test run
    Given THIS IS A MANUAL TEST

  Scenario Outline: Verify EACH product page has the correct Information - navigate to each product and check content vs. product guide
    Given I am on the home page
    When I search or navigate to each product
    Then I should see the title
    And I should see the correct image per the product owners product guide
    And I should see the correct description
    And I should see the correct original Price
    And I should see the correct sale price if applicable
    And I should see the Add to Cart button
    And I should see the Rating Stars
    And I should see the Facebook like
    And I should see the Additional Information section with the correct information per the product owners product guide
    And I should see the Suggested Additional Purchases section with the correct information per the product owners product guide
