require 'bundler'
require 'mail'
require 'slack-notifier'
require 'pry'
require 'httparty'
require 'uri'

#chromedriver version required for jenkins
cdv = "2.37"

#slack_speak
testroom = Slack::Notifier.new "https://hooks.slack.com/services/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", channel: 'testroom',
                               username: 'T2TestBot' #slack_speak
full_stack_notifs = Slack::Notifier.new "https://hooks.slack.com/services/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", channel: 'full_stack_notifs',
                                        username: 'T2TestBot'

namespace :aws do
  desc "Run aws create and execute[tag]"
  task :batch, [:tag] do |t, args|
    Rake::Task["aws:create"].invoke(args[:tag])
    Rake::Task["aws:execute"].invoke(args[:tag])
  end

  desc "Create a new aws instance"
  task :create, [:name, :channel, :license] do |t, args|
    if args[:license]
      testroom.ping "!customer_create --customer-name #{args[:name].gsub('@', '')} --environment #{args[:channel]} --license-token #{args[:license]}  --url-prefix #{args[:name].gsub('@', '')}"
    else
      testroom.ping "!customer_create --customer-name #{args[:name].gsub('@', '')} --environment #{args[:channel]} --url-prefix #{args[:name].gsub('@', '')}"
    end
    sleep 1200 #need to wait 20 minutes for new instances to build before testing
  end

  desc "Run a set of specifc cucumber @tags"
  task :execute, [:tag] do |t, args|
    # testroom.ping "Running `#{args[:tag]}` scenarios against https://#{args[:tag].gsub('@', '')}.pmsbx.io aws instance"
    IO.popen("thor env:dynamic_domain && HEADLESS=true AWS_URL=https://#{args[:tag].gsub('@', '')}.pmsbx.io cucumber -t @smoketest") do |pipe|
      puts console_output = pipe.read
      pipe.close_write
    end
    if args[:tag].gsub('@', '') == "wip"
      IO.popen("thor env:dynamic_domain && HEADLESS=true AWS_URL=https://#{args[:tag].gsub('@', '')}.pmsbx.io cucumber -t #{args[:tag]} -t 'not @applitools' -t 'not @manual' -t 'not @performance' -t 'not @deploy' --format pretty -f rerun --out rerun.txt", 'r+') do |pipe|
        puts console_output = pipe.read
        pipe.close_write
      end
    elsif args[:tag].gsub('@', '') == "manual"
      IO.popen("thor env:dynamic_domain && HEADLESS=true AWS_URL=https://#{args[:tag].gsub('@', '')}.pmsbx.io cucumber -t #{args[:tag]} -t 'not @wip' -t 'not @applitools'  -t 'not @performance' -t 'not @deploy' --format pretty -f rerun --out rerun.txt", 'r+') do |pipe|
        puts console_output = pipe.read
        pipe.close_write
      end
    elsif args[:tag].gsub('@', '') == "performance"
      IO.popen("thor env:dynamic_domain && HEADLESS=true AWS_URL=https://#{args[:tag].gsub('@', '')}.pmsbx.io cucumber -t #{args[:tag]} -t 'not @wip' -t 'not @applitools' -t 'not @manual' -t 'not @deploy' --format pretty -f rerun --out rerun.txt", 'r+') do |pipe|
        puts console_output = pipe.read
        pipe.close_write
      end
    else
      IO.popen("thor env:dynamic_domain && HEADLESS=true AWS_URL=https://#{args[:tag].gsub('@', '')}.pmsbx.io cucumber -t #{args[:tag]} -t 'not @wip' -t 'not @manual' -t 'not @applitools'  -t 'not @performance' -t 'not @deploy' --format pretty -f rerun --out rerun.txt", 'r+') do |pipe|
        puts console_output = pipe.read
        pipe.close_write
      end
    end
    IO.popen("thor env:dynamic_domain && HEADLESS=true AWS_URL=https://#{args[:tag].gsub('@', '')}.pmsbx.io cucumber @rerun.txt", 'r+') do |pipe|
      puts "** RE-RUNNING FAILED SCENARIOS **"
      puts console_output = pipe.read
      if console_output.to_s.include? "Failing Scenarios:"
        # full_stack_notifs.ping "`#{args[:tag]} Failing Scenarios:`"
        # full_stack_notifs.ping "```#{console_output.to_s.split("Failing Scenarios:").last}```"
      end
      pipe.close_write
    end
  end

  desc "Destroy an aws instance"
  task :destroy, [:name] do |t, args|
    testroom.ping "!customer destroy --customer-name #{args[:name].gsub('@', '')}"
  end

  desc "Check infrastructure for an existing aws instance"
  task :infra, [:name] do |t, args|
    testroom.ping "!customer infrastructure --customer-name #{args[:name].gsub('@', '')}"
  end

  desc "List existing T2TestBot aws instances"
  task :list do
    testroom.ping "!customer list"
  end
end

namespace :testbot do
  instances = ["admin", "cluster", "notifications", "playbooks", "remaining", "reporters", "rules"]
  desc "Spin Up T2 TestBot internal_qa aws instances"
  task :spin_up_aws do
    Rake::Task["aws:create"].invoke(name, "qa")
  end

  desc "Remove T2 TestBot internal_qa aws instances"
  task :tear_down_aws do
    instances.each do |name|
      Rake::Task["aws:destroy"].invoke(name)
    end
  end
end