@product-category @1-0
Feature:  Product Category
  Acceptance Criteria:
  Notes:
    Since products and pricing could change each release, the may need to be a manual test.
    However, it could be automated by using something that would feed into the automated tests, like a csv file
      that contains product, placement (homepage slider), original price, sale price, image, etc.

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
