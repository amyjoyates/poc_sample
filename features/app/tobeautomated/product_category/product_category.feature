@product-category @1-0
Feature:  Product Category
  Acceptance Criteria:

Scenario: Verify the list of products
  Given I am on the home page
  When I hover over Product Category Navigation
  Then I should see "Accessories" on the page
  And I should see "iMacs" on the page
  And I should see "iPads" on the page
  And I should see "iPhones" on the page
  And I should see "iPods" on the page
  And I should see "MacBooks" on the page

  Scenario Outline: Verify clicking on each link in the product category navigation menu takes you to the correct page
  Examples:
  | category | link |
  | Product Category | http://store.demoqa.com/products-page/product-category/ |
  | Accessories | http://store.demoqa.com/products-page/product-category/accessories/ |
  | iMacs | http://store.demoqa.com/products-page/product-category/imacs/  |
  | iPads | http://store.demoqa.com/products-page/product-category/ipads/ |
  | iPhones | http://store.demoqa.com/products-page/product-category/iphones/ |
  | iPods | http://store.demoqa.com/products-page/product-category/ipods/ |
  | MacBooks | http://store.demoqa.com/products-page/product-category/macbooks/ |

  Scenario Outline: Verify Accessory Pricing

  Examples:
  | Name | Original | Sale | Discount | Rating |
  | Magic Mouse | 200.00 | 150.00  | 50.00  | 3 |
  | Apple TV | 89.00 | 80.00 | 9.00 | 3 |
  | Sennheiser RS 120 | 60.00 | 50.00  | 10.00 | 3 |
  | Skullcandy PLYR 1 – Black | 129.00 | 110.00 | 19.00 | 3 |
  | Apple 27 inch Thunderbolt Display | 899.00 | 764.00 | 135.00 | 3 |
  | Asus MX239H 23-inch Widescreen AH | 249.99 | 199.00 | 50.00 | 4 |

  Scenario Outline: Verify each category page has the correct products listed
  Examples:
  | Product Category |
  | Accessories |
  | iMacs |
  | iPads |
  | iPhones |
  | iPods |
  | MacBooks |

  #new tests for 1-1
  @1-1
  Scenario: Verify Registration from Product Category Page is not present
  Scenario: Verify Login from the Product Category Page is not present
  Scenario: Verify that a customer can create a product review on the Product page
  Scenario: Verify that a customer can view a review of the product on the product Page
  Scenario: Verify if a review is removed, then a customer can no longer see that review
