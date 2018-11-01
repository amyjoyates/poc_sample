@home
Feature:  Home
  Acceptance Criteria:

  Scenario: Verify Slider on homepage automatically goes to next product
    Given I am on the home page
    When Right after the navigation menu
    Then I should see a slider with 3 products
    And they should automatically slide to the next product every 5 seconds

  Scenario: Verify Static Slider Content: Title, Image, Content, Price and Buy Now button
    Given I am on the home page
    When Right after the navigation menu
    Then I should see the Buy Now button
    And I should see the product <title>
    And I should see the product <image>
    And I should see the product <description>
    And I should see the product <price>

    Examples:
    | title | image | description | price |
    | Magic Mouse | magicmouse.png | | |
    | iPod Nano Blue | iPod-Nano-silver-on1.png | | |
    | iPhone 5| timthumb.png | | |

  Scenario: Verify clicking on image navigates to product page

  Scenario: Verify clicking on More info

  Scenario Outline: Verify Buy Now button takes you to the correct product page - note feature products could change
    Given I am on the home page
    And Right after the navigation menu
    When I click Buy Now for <product>
    Then I should be on the <product> page

    Examples:
    | product |
    | Magic Mouse |
    | iPod Nano Blue |
    | iPhone 5|

  Scenario: Verify slider navigation dots navigate to products
    Given I am on the home page
    And Right after the navigation menu
    When I click the <page> dot for the slider navigation
    Then I should be on the <product> page

    Examples:
    | page | product |
    | First | Magic Mouse |
    | Second | iPod Nano Blue |
    | Third | iPhone 5|

  Scenario: Verify Registration is not present on the home page
  Scenario: Verify Login is not present on the home page
