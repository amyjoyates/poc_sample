require 'slack-notifier'
t2_performance = Slack::Notifier.new "https://hooks.slack.com/services/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", channel: 't2_performance',
                                     username: 'T2TestBot'

Given /I track how long it takes to ingest "(.*)" messages/i do |messages|
  # Count all messages and save
  message_count_prior = @messages.total_count(@domain)
  t2_performance.ping "********************************************************************************"
  t2_performance.ping "#{@domain} is running System Version: " + @system_updates_api.system_version(@domain, @common_api)
  t2_performance.ping "********************************************************************************"
  t2_performance.ping "`#{message_count_prior.to_s}` total messages in the Core DB prior to ingestion"

  #GET all integrations
  request_url = (@domain + "/v1/module/triage/integrations")
  @request_url = URI.escape(request_url)
  @response = HTTParty.get(@request_url.to_str,
                           :body => {}.to_json,
                           :headers => {'x-auth-token' => $superuser_token, 'Content-Type' => 'application/json'})
  t2_performance.ping "*Cofense PhishMe* Integration"
  @response.parsed_response["payload"].each do |integration|
    if integration["enabled"] == true && integration["validate"] == true && integration["created"] == true
      t2_performance.ping "*#{integration["name"]}* Integration"
      puts integration["name"]
    end
  end

  seconds = 0
  while @messages.total_count(@domain) < (messages.to_i + message_count_prior)
    sleep 1
    puts seconds += 1
  end

  # Post results to slack t2_perforamnce channel
  message_count_after = @messages.total_count(@domain)
  total_messages = message_count_after - message_count_prior
  t2_performance.ping "`#{message_count_after.to_s}` total messages in the Core DB after #{total_messages.to_s} messages were ingested"
  mins = seconds.to_f / 60.to_f
  t2_performance.ping "`#{mins.round(2).to_s} minutes` for #{@domain} to ingest #{total_messages.to_s} messages"
  avg_ingestion = total_messages / mins
  rule_count = @rules_api.count(@domain, @common_api).to_s
  t2_performance.ping "*Ingestion Rate:* `#{avg_ingestion.round(2).to_s}` messages/minute with `#{rule_count}` Rules."
  @test_time = avg_ingestion.round(2).to_s
  @time_unit = "messages/minute"
end

Given /I check the total message count/i do
  @messages = Messages.new(@browser)
  puts "Total Messages == #{@messages.total_count(@domain)}"
end

Given /I make sure clusters load in less then 5 seconds/i do
  t2_performance.ping "********************************************************************************"
  t2_performance.ping "#{@domain} is running System Version: " + @system_updates_api.system_version(@domain, @common_api)
  t2_performance.ping "********************************************************************************"

  #GET all integrations
  request_url = (@domain + "/v1/module/triage/integrations")
  @request_url = URI.escape(request_url)
  @response = HTTParty.get(@request_url.to_str,
                           :body => {}.to_json,
                           :headers => {'x-auth-token' => $superuser_token, 'Content-Type' => 'application/json'})
  t2_performance.ping "*Cofense PhishMe* Integration"
  @response.parsed_response["payload"].each do |integration|
    if integration["enabled"] == true && integration["validate"] == true && integration["created"] == true
      t2_performance.ping "*#{integration["name"]}* Integration"
      puts integration["name"]
    end
  end

  @cluster_load = ClusterLoad.new(@browser)
  @cluster_load.check_page_performance
end

Then /I post test yara rule button results in slack/ do
  rule_count = @rules_api.count(@domain, @common_api).to_s
  sleep 2
  @browser.first(class: 'rule-builder-yara-drawer__actions').first(class: 'rule-builder-yara-drawer__test').click

  message_count_prior = @messages.total_count(@domain)

  notifier.ping "Yara Test Rule button was just clicked in #{@domain}"
  notifier.ping "There are a total of `#{message_count_prior}` messages and `#{rule_count}` rules in the Core DB for #{@domain}"
  sleep 2
  start_time = Time.now.to_i
  sleep 1 while @browser.first(class: 'rule-builder-yara-drawer__matching-messages-section').first(class: 'total-count').text == "-"
  sleep 1
  end_time = Time.now.to_i - start_time
  $test_time = end_time
  puts (end_time / 60.to_f).round(2).to_s + " minutes time to test this rule."
  notifier.ping (end_time / 60.to_f).round(2).to_s + " minutes to test this rule."
  puts @browser.first(class: 'rule-builder-yara-drawer__matching-messages-section').first(class: 'matching-count').text + " matching messages in CLUSTER."
  notifier.ping @browser.first(class: 'rule-builder-yara-drawer__matching-messages-section').first(class: 'matching-count').text + " matching messages in CLUSTER."
  msgs = @browser.first(class: 'rule-builder-yara-drawer__matching-clusters-section').first(class: 'matching-count').text
  puts msgs + " matching messages in INBOX."
  t2_performance.ping msgs + " matching messages in INBOX."
  t2_performance.ping "*Yara Test Rule Rate:* `#{(message_count_prior.to_i / (end_time / 60.to_f).round(2)).to_s}` messages/minute"
  @test_time = (message_count_prior.to_i / (end_time / 60.to_f).round(2)).to_s
  @time_unit = "messages/minute"
end


Given /I POST 5k Rules/i do
  threads = []
  rules = ["_PERF0", "_PERF1", "_PERF2", "_PERF3", "_PERF4", "_PERF5", "_PERF6", "_PERF7", "_PERF8", "_PERF9"]
  500.to_i.times do
    rules.each do |rule_name|
      threads << Thread.new(rule_name) do |rule_name|
        @rules_api.insert(@unique_string + rule_name + rand(999999999999999).to_s, @domain, @common_api)
      end
    end
    threads.each {|thread| thread.join}
  end
end

Given /I track how long it takes to render notifications index/i do
  notif_count = @notifications_api.count(@domain, @common_api)
  start_time = Time.now
  @browser.get(@domain + '/notifications')
  Selenium::WebDriver::Wait.new(:timeout => 10).until {@browser.first(class: 'notification-list-item-data').displayed?}
  puts result = "`#{(end_time = Time.now - start_time).round(2)}`" + " seconds to render `#{notif_count.to_s}` notifications on the notifications index page"
  t2_performance.ping result.to_s

end

Given("I track how long it takes to filter notifications") do
  notif_count = @notifications_api.count(@domain, @common_api)
  @notifications_index.search.send_keys(":")
  Selenium::WebDriver::Wait.new(:timeout => 10).until {@browser.first(class: 'no-results').displayed?}
  @notifications_index.search.clear
  start_time = Time.now
  @notifications_index.search.send_keys("BOT_DATA-template-")
  Selenium::WebDriver::Wait.new(:timeout => 10).until {@browser.first(class: 'search__count').displayed?}
  Selenium::WebDriver::Wait.new(:timeout => 10).until {@browser.first(class: 'notification-list-item-data').displayed?}
  result_time = (end_time = Time.now - start_time).round(2).to_s
  @test_time = result_time.to_s
  @time_unit = "seconds"
  puts result = "`#{result_time}`" + " seconds to filter `#{notif_count.to_s}` notifications"
  t2_performance.ping result.to_s
end

Given /I track how long it takes to render rules index/i do
  rule_count = @rules_api.count(@domain, @common_api)
  start_time = Time.now
  @browser.get(@domain + '/rules')
  Selenium::WebDriver::Wait.new(:timeout => 10).until {@browser.first(class: 'rule-list-item-data').displayed?}
  puts result = "`#{(end_time = Time.now - start_time).round(2)}`" + " seconds to render `#{rule_count.to_s}` rules on the rules index page"
  t2_performance.ping result.to_s
end

Given("I track how long it takes to filter rules") do
  rule_count = @rules_api.count(@domain, @common_api)
  @rules_index.search.send_keys(":")
  Selenium::WebDriver::Wait.new(:timeout => 10).until {@browser.first(class: 'no-results').displayed?}
  @rules_index.search.clear
  start_time = Time.now
  @rules_index.search.send_keys("BOT_DATA")
  Selenium::WebDriver::Wait.new(:timeout => 10).until {@browser.first(class: 'search__count').displayed?}
  Selenium::WebDriver::Wait.new(:timeout => 10).until {@browser.first(class: 'rule-list-item-data').displayed?}
  result_time = (end_time = Time.now - start_time).round(2).to_s
  @test_time = result_time.to_s
  @time_unit = "seconds"
  puts result = "`#{result_time}`" + " seconds to filter `#{rule_count.to_s}` rules"
  t2_performance.ping result.to_s
end

Given /I track how long it takes to render playbooks index/i do
  pb_count = 1000
  start_time = Time.now
  @browser.get(@domain + '/playbooks')
  Selenium::WebDriver::Wait.new(:timeout => 10).until {@browser.first(class: 'playbooks-index__body').displayed?}
  result_time = (end_time = Time.now - start_time).round(2).to_s
  @test_time = result_time.to_s
  @time_unit = "seconds"
  puts result = "`#{result_time}`" + " seconds to render `#{pb_count.to_s}` playbooks on the playbooks index page"
  t2_performance.ping result.to_s
end

Given /I track how long it takes to filter playbooks/i do
  pb_count = 1000
  @rules_index.search.send_keys(":")
  Selenium::WebDriver::Wait.new(:timeout => 10).until {@browser.first(class: 'no-results').displayed?}
  @playbooks_index.search.clear
  start_time = Time.now
  @playbooks_index.search.send_keys("BOT_DATA")
  Selenium::WebDriver::Wait.new(:timeout => 10).until {@browser.first(class: 'search__count').displayed?}
  Selenium::WebDriver::Wait.new(:timeout => 10).until {@browser.first(class: 'playbooks-index__body').displayed?}
  result_time = (end_time = Time.now - start_time).round(2).to_s
  @test_time = result_time.to_s
  @time_unit = "seconds"
  puts result = "`#{result_time}`" + " seconds to filter `#{pb_count.to_s}` playbooks"
  t2_performance.ping result.to_s
end

Given /I track how long it takes to search clusters/i do
  msg_count = @messages.total_count(@domain)
  start_time = Time.now
  @cluster_list.search("_DATA")
  Selenium::WebDriver::Wait.new(:timeout => 100).until {@browser.find_element(:tag_name => "body").text.include? "BOT_DATA1"}
  result_time = (end_time = Time.now - start_time).round(2).to_s
  @test_time = result_time.to_s
  @time_unit = "seconds"
  puts result = "`#{result_time}`" + " seconds to search cluster list through `#{msg_count.to_s}` messages"
  t2_performance.ping result.to_s
end

Given /I track how long it takes to filter clusters/i do
  msg_count = @messages.total_count(@domain)
  start_time = Time.now
  @cluster_list.filter_and_sort_by_button.click
  steps %Q{ * I click on Apply button from Filter-Sort By modal }
  result_time = (end_time = Time.now - start_time).round(2).to_s
  @test_time = result_time.to_s
  @time_unit = "seconds"
  puts result = "`#{result_time}`" + " seconds to filter sort the cluster list with `#{msg_count.to_s}` messages"
  t2_performance.ping result.to_s
end

Given /I track how long it takes to search for subject in explore/i do
  msg_count = @messages.total_count(@domain)
  steps %Q{ * I am on the explore page }
  start_time = Time.now
  @explore.subject.send_keys("BOT_DATA1")
  @explore.search.click
  Selenium::WebDriver::Wait.new(:timeout => 60).until {@browser.first(class: 'explore-results-table__message_link').displayed?}
  result_time = (end_time = Time.now - start_time).round(2).to_s
  @test_time = result_time.to_s
  @time_unit = "seconds"
  puts result = "`#{result_time}`" + " seconds to search by subject on the explore page through `#{msg_count.to_s}` messages "
  t2_performance.ping result.to_s
end