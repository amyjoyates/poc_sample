@footer @manual @1-0
Feature:  Footer

Background: Make sure you start on the homepage
  Given I am on the home page

  Scenario: Verify Pinterest Link
    When I navigate to "Latest Blog Post"
    Then I should see "Follow our Pins" on the page
    When I click pinterest link
    Then I should navigate to the pinterest page for the demo store

  Scenario: Verify Google Plus Link
    When I navigate to "Latest Blog Post"
    Then I should see "Checkout our Google Plus Profile" on the page
    When I click Google Plus link
    Then I should navigate to the Google Plus page for the demo store

  Scenario: Verify RSS Feed
    When I navigate to "Latest Blog Post"
    Then I should see "Get Fed on our Feeds" on the page
    When I click RSS link
    Then I should navigate to the RSS feed page for the demo store

  Scenario: Verify Copyright
    When I navigate to "Latest Blog Post"
    Then I should see "Copyright © Splashing Pixels, All Rights Reserved" on the page
    And The copyright should not be clickable

  Scenario Outline: Verify links to various pages
    And I navigate to "Latest Blog Post"
    And I should see <name> on the page
    When I click <name> link
    Then I should navigate to the <name> page for the demo store
    And The url should be <link>

    Examples:
    | name | link |
    | SP Home | http://store.demoqa.com/ |
    | Sample Page | http://store.demoqa.com/sample-page/ |
    | Your Account | http://store.demoqa.com/products-page/your-account/ |
