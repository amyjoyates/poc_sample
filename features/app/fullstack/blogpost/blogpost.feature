@checkout @cart @1-0
Feature:  Checkout
 Acceptance Criteria:

  @happy-path
  Scenario: Verify Blog Posts on all pages
    Given I am on the home page
    When I scroll to the section called "Latest Blog Post"
    Then I should see a section with blog posts
    And I navigate to the checkout Page
    When I scroll to the section called "Latest Blog Post"
    Then I should see a section with blog posts
    And I navigate to the my account Page
    When I scroll to the section called "Latest Blog Post"
    Then I should see a section with blog posts

  Scenario: Verify selection of a blog post
    Given I am on the home page
    And I scroll to the section called "Latest Blog Post"
    When I select a blog post
    Then I should navigate to the product page of that blog post
