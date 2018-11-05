@blogpost @manual @1-0
Feature:  Blog Posts

 Scenario: Verify blog posts change order with each load of the page
    Given I am on the home page
    And I make note of the order of the blog posts
    And I refresh the page
    When I scroll to the section called "Latest Blog Post"
    Then I should see a different order or product in the blog post section

 Scenario: Verify blog post selection by clicking more details
    Given I am on the home page
    And I scroll to the section called "Latest Blog Post"
    When I click on More Details for the first blog post
    Then I should go to the product page for that item
