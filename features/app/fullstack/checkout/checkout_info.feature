@checkout @info @1-0
Feature:  Checkout Info page
 Acceptance Criteria:

Scenario: Verify Shipping Price - Selecting Country with Valid state
Scenario: Verify Shipping Price - Selecting Country and adding an invalid state option (or secondary choice)

@happy-path
Scenario: Verify Account Login with valid account

Scenario: Verify Account Login with blank account information
Scenario: Verify Account Login with incorrect account information
Scenario: Verify Account Login remember me checkbox

@happy-path
Scenario: Verify Using Guest Checkout with valid data - should not be able to continue

Scenario: Verify field level validation - this would be split out into multiple scenarios based upon each field

Scenario: Verify entering no data into fields
Scenario: Verify correct totals for the order
Scenario: Verify checkout is secure (https)
Scenario: Verify using Billing Address as Shipping Address
Scenario: Verify purchase again after first order saves information on the info page in checkout so you don't re-enter data
Scenario: Verify tax on products
