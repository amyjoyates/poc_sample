  Given(/^I enter "(.*)" into the search page$/) do |string|
    @search.search_field(string)
  end
