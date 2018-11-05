@search
Feature: Search
  Acceptance Criteria:


  Background: Not Automated yet
    Given THIS IS CURRENTLY NOT AUTOMATED BUT WILL BE

  Scenario: Verify Search when left blank, results page shows "Sorry, but nothing matched your search criteria. Please try again with some different keywords."
  Scenario: Verify Search with data that won't match, results page shows "Sorry, but nothing matched your search criteria. Please try again with some different keywords."
  Scenario: Verify Search minimal char
  Scenario: Verify Search maximize char
  Scenario: Verify Search by Full Product Name
  Scenario: Verify Search by partial product Name
  Scenario: Verify Search by Product Description
  Scenario: Verify Search by Price
  Scenario: Verify Search with mixed case chars (iMac vs imac vs IMAC vs IMac)

  @security
  Scenario: Verify Search input box cannot be hacked by sending javascript
