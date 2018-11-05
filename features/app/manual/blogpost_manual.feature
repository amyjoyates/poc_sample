@blogpost @manual
Feature:  Blog Posts

Background: Manual Test - speeds up test run
  Given THIS IS A MANUAL TEST

  Scenario: Verify blog posts change order with each load of the page
    Given I am on the home page
    And I make note of the order of the blog posts
    And I refresh the page
    When I scroll to the section called "Latest Blog Post"
    Then I should see a different order or product in the blog post section

  Scenario: Verify blog post selection by clicking "more details"
    Given I am on the home page
    And I scroll to the section called "Latest Blog Post"
    When I click on More Details for the first blog post
    Then I should go to the product page for that item

  Scenario: Verify clicking on blog project image takes you to the product page
  Scenario: Verify Title of blog post
