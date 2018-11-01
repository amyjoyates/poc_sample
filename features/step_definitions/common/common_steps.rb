Then /I should (NOT )?see "(.*)" on the page/i do |visibility, text|
  text = text.to_s.strip
  if (visibility.to_s.strip == 'NOT') then
    Selenium::WebDriver::Wait.new(:timeout => 7).until {!@browser.find_element(:tag_name => "body").text.include? text}
    @browser.find_element(:tag_name => "body").text.should_not include("#{text}")
  else
    Selenium::WebDriver::Wait.new(:timeout => 10).until {@browser.find_element(:tag_name => "body").text.include? text}
    @browser.find_element(:tag_name => "body").text.should include("#{text}")
  end
end

Then /I should (NOT )?be on the "(.*)" page/ do |visibility, value|
  if (visibility.to_s.strip == 'NOT') then
    @browser.current_url.to_s.should_not include value
  else
    Selenium::WebDriver::Wait.new(:timeout => 5).until {@browser.current_url.to_s.include? value}
  end
end

Then /I should see "(.*)" in the page title/ do |value|
  Selenium::WebDriver::Wait.new(:timeout => 5).until {@browser.title.include? value}
end

Given /I verify "(.*)" with applitools/i do |page|
  # Do not run applitools if headless or APPLITOOLS ENV is not true
  if @headless == true || (ENV['APPLITOOLS'] =~ /^(true)$/i) != 0
    puts '** Applitools is disabled - NO VERIFICATION OF RESULT**'
  else
    $eyes.check_window(page)
    puts "** Applitools verified the #{page} in #{@browser.capabilities.browser_name.upcase}"
  end
end

Given /I enter new tab/ do
  @browser.current_url
  @browser.title
  @browser.switch_to.window(@browser.window_handles.last)
  @browser.window_handle
  @browser.current_url
  @browser.title
end

Given /I switch to the originial tab/i do
  @browser.switch_to.window(@browser.window_handles.last)
  @browser.switch_to.window(@browser.window_handles.first)
end

And /I switch to the last browser tab/i do
  @browser.switch_to.window(@browser.window_handles.last)
end

Given /I login as (.*) with a password of (.*)/ do |login, password|
  pending "add steps for login"
end

Given /I refresh the page/i do
  sleep 2
  @browser.navigate.refresh
end

Given(/^I click YES on the Cancel modal$/) do
  @common.confirm_modal_yes.click
  sleep 1
end

Given(/^I click NO on the Cancel modal$/) do
  @common.confirm_modal_no.click
  sleep 1
end

Given /I wait for "(.*)" seconds/ do |sleeptime|
  sleep sleeptime.to_i
end

Given /I should (NOT )?see the unique id on the page/i do |visibility|
  steps %Q{ * I should #{visibility}see "#{@unique_id}" on the page }
end

Given /I press the enter key/i do
  @browser.action.send_keys(:return).perform
end

Given /I press the escape key/i do
  @browser.action.send_keys(:escape).perform
end

Given /I perform a search in the navigation bar using "(.*)"/i do |value|
  @common.nav_search.clear
  @common.nav_search.send_keys(value)
  @browser.action.send_keys(:return).perform
  sleep 1
end

Given /I clear the (.*) field/ do |field_id|
  Selenium::WebDriver::Wait.new(:timeout => 5).until {@browser.first(id: field_id)}
  @browser.first(id: field_id).click
  500.times do
    @browser.action.send_keys(:backspace).perform
  end
  @browser.action.send_keys(:return).perform
end

Given /I click back button in browser/i do
  @browser.navigate.back
end

When /I press the tab key "(.*)" times/i do |press|
  press.to_i.times do
    @browser.action.send_keys(:tab).perform
  end
end

When(/^I resize window to (.*) by (.*)$/) do |width, height|
  @common.resize_window(width, height)
end
