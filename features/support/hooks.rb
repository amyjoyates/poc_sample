require 'cucumber'
require 'selenium-webdriver'
require 'rspec'
require 'page-object'
require 'pry'
require 'eyes_selenium'
require 'watir'
require 'uri'
require 'user_agent_parser'
require 'httparty'
require 'uri'
require 'httparty/parser'
require 'ruby-jmeter'

AfterConfiguration do |config|
  # Setting a unique id based on the date time for setting the test_id for the test run (for grouping)
  # Set env var for test_id so you can pass in one already used
  if ENV['TESTID']
    $testrun_batch = ENV['TESTID']
  else
    $testrun_batch = Time.now.utc.to_i
  end
  puts("** #{$testrun_batch} **")
end

Before do |scenario|
  if scenario.source_tag_names.include? '@smoketest'
    @typeoftest = 'smoke'
  else
    @typeoftest = 'regression'
  end

  # puts "Running scenarios in " + @browser.capabilities.browser_name.upcase + " " + @browser.capabilities.version + " against #{@domain}" unless @browser.inspect =~ /safari/ || @browser.inspect =~ /MicrosoftEdge/ || @browser.inspect =~ /Firefox/
  @browser.manage.timeouts.implicit_wait = 30
  if ENV['APPLITOOLS']
    puts '** Applitools is enabled **'
    $eyes = Applitools::Selenium::Eyes.new
    $eyes.batch = $batchInfo
    $eyes.api_key = ''
    $eyes.hide_scrollbars = true
    $eyes.open(app_name: 'POC', test_name: 'POC ' \
           + @browser.capabilities.browser_name.upcase + ' ~ ' \
           + scenario.feature.to_s + ' ~ ' + scenario.name.to_s, driver: @browser) unless @browser.inspect =~ /safari/
  else
    puts '** Applitools is disabled **'
  end

  # Common things
  @unique_string = 'TEST_DATA'
  @unique_id = rand(999999).to_s

  # search
  @search = Search.new(@browser)

  # Homepage
  @homepage = Homepage.new(@browser)
  
  # Miscellaneous
  @common = Common.new(@browser)
  @common_api = CommonApi.new(@browser, @httparty_options)
  @performance = Performance.new(@browser)

end

After do |scenario|
  if ENV['REPORT_RESULTS']
    puts '** Start Posting Results **'
    if ENV['PERF']
      '** Report Perf Results **'
      report_res_perf(scenario)
    else
      '** Report Regression Results **'
      report_res(scenario)
    end
  else
    puts '** Do not report test results to metrics api **'
  end
end

def report_res(scenario)
  release = ENV['RELEASENAME']
  uri = URI.parse(@domain)
  steps = scenario.test_steps.map {|step| step.text}.compact.join("\n")

  cmp = scenario.source_tag_names.to_s.delete('@[]"')
  if cmp.include?('qa-only')
    assigned = 'qa'
  elsif cmp.include?('applitools')
    assigned = 'qa'
  else
    assigned = 'tbd'
  end

  status = scenario.status.to_s
  if status.include?('passed')
    testtype = 'automated'
    status = 'passed'
    assigned = 'AUTOMATION'
  elsif status.include?('failed')
    testtype = 'failed-automation'
    status = 'todo'
    assigned = 'qa'
  else
    testtype = 'manual'
    status = 'todo'
  end

  bua = @browser.execute_script('return navigator.userAgent;')
  user_agent = UserAgentParser.parse bua
  #scenario.source_tag_names.first(2).delete('@')

  test_steps = steps.to_s.delete('"')
  test_steps.gsub!('Before hook', '')
  test_steps.gsub!('AfterStep hook', '')
  test_steps.gsub!(/^$\n/, '')

  request_url = 'http://10.1.23.9/testing_results.json'
  response = HTTParty.post(
      request_url,
      body:
          {
              test_id: $testrun_batch,
              release_name: release,
              test_name: scenario.feature.to_s + ' - ' + scenario.name.to_s,
              product: 'T2APP',
              test_status: status,
              test_type: testtype,
              test_env: uri.host,
              os: user_agent.os.to_s,
              os_version: '',
              browser: user_agent.family,
              browser_version: user_agent.version.to_s,
              test_steps: test_steps,
              updated_on: Date.today,
              updated_by: 'jenkins',
              test_component: cmp,
              build_commit_id: @system_updates_api.build_commit_id(@domain).to_s,
              build_version_id: @system_updates_api.build_version(@domain).to_s,
              system_version: @system_updates_api.system_version(@domain, @common_api).to_s,
              assigned_to: assigned
          }.to_json,
      headers: {'Content-Type' => 'application/json'}
  )
  response.code.should == 201
  puts '** Finished Posting Results **'
end

def report_res_perf(scenario)
  release = ENV['RELEASENAME']
  uri = URI.parse(@domain)
  steps = scenario.test_steps.map {|step| step.text}.compact.join("\n")
  status = scenario.status.to_s
  if status.include?('passed')
    testtype = 'automated'
  elsif status.include?('failed')
    testtype = 'fix-rerun'
  else
    testtype = 'manual'
    status = 'todo'
  end

  bua = @browser.execute_script('return navigator.userAgent;')
  user_agent = UserAgentParser.parse bua
  @request_url = URI.escape('http://10.1.23.9/perf_results.json')
  @response = HTTParty.post(@request_url.to_str,
                            :body => {
                                :test_id => $testrun_batch,
                                :release_name => release,
                                :test_name => scenario.feature.to_s + ' - ' + scenario.name.to_s,
                                :test_time => @test_time,
                                :time_unit => @time_unit,
                                :product => 'T2APP',
                                :test_status => status,
                                :test_type => testtype,
                                :test_env => uri.host,
                                :os => user_agent.os.to_s,
                                :os_version => '',
                                :browser => user_agent.family,
                                :browser_version => user_agent.version.to_s,
                                :test_steps => steps.to_s.delete('"'),
                                :updated_on => Date.today,
                                :updated_by => 'jenkins',
                                build_commit_id: @system_updates_api.build_commit_id(@domain).to_s,
                                build_version_id: @system_updates_api.build_version(@domain).to_s,
                                system_version: @system_updates_api.system_version(@domain, @common_api).to_s
                            }.to_json,
                            headers: {'Content-Type' => 'application/json'}
  )
  @response.code.should == 201
  puts "Test Results Posted"
  puts('************************')
end
