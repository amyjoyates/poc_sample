require 'bundler'
require 'mail'
require 'slack-notifier'
require 'pry'
require 'httparty'
require 'uri'

cdv = "2.37"
full_stack_notifs = Slack::Notifier.new "https://hooks.slack.com/services/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", channel: 'full_stack_notifs',
                                        username: 'T2TestBot'

namespace :add do

  desc "Add 5k Random Triage Rules to your test environment"
  task :rules, [:url] do |t, args|
    puts "** Adding 5K Rules to #{args[:url]}"
    puts " * This may take a minute... \u2615"
    IO.popen("thor env:dynamic_domain && HEADLESS=true AWS_URL=#{args[:url]} cucumber -t @add_multiple_rules ", 'r+') do |pipe|
      puts console_output = pipe.read
      pipe.close_write
    end
  end

  desc "Add all users with each user type to your test environment"
  task :all_users, [:url] do |t, args|
    puts "** Creating or confirming the below users exist in #{args[:url]}"
    puts " * admin@example.com / P@ssw0rd!"
    puts " * superuser@example.com / P@ssw0rd!"
    puts " * operator@example.com / P@ssw0rd!"
    puts " * user@example.com / P@ssw0rd!"
    puts " * suboperator@example.com / P@ssw0rd!"
    puts " * This may take a minute... \u2615"
    IO.popen("thor env:dynamic_domain && HEADLESS=true AWS_URL=#{args[:url]} cucumber -t @create-all-users --format pretty -f rerun --out rerun.txt", 'r+') do |pipe|
      puts console_output = pipe.read
      pipe.close_write
    end
    IO.popen("thor env:dynamic_domain && HEADLESS=true AWS_URL=#{args[:url]} cucumber @rerun.txt", 'r+') do |pipe|
      puts "** RE-RUNNING FAILED SCENARIOS **"
      puts console_output = pipe.read
      pipe.close_write
    end
  end

  desc "Add all integrations to your test environment"
  task :integrations, [:url] do |t, args|
    puts "** Configuring the below integrations in #{args[:url]}"
    puts " * SYSLOG"
    puts " * Cuckoo"
    puts " * Who Else"
    puts " * VirusTotal"
    puts " * Browser Quick Links"
    puts " * Triage Noise Reduction"
    puts " * Cofense PhishMe"
    puts " * Lastline Analyst"
    puts " * This may take a minute... \u2615"
    IO.popen("thor env:dynamic_domain && HEADLESS=true AWS_URL=#{args[:url]} cucumber -t @setup-all-integrations --format pretty -f rerun --out rerun.txt", 'r+') do |pipe|
      puts console_output = pipe.read
      pipe.close_write
    end
    IO.popen("thor env:dynamic_domain && HEADLESS=true AWS_URL=#{args[:url]} cucumber @rerun.txt", 'r+') do |pipe|
      puts "** RE-RUNNING FAILED SCENARIOS **"
      puts console_output = pipe.read
      pipe.close_write
    end
  end
end

namespace :config do
  desc "Configure your test environment with EWS"
  task :ews, [:url] do |t, args|
    puts " * Configuring #{args[:url]} with EWS, this may take a minute... \u2615"
    IO.popen("thor env:dynamic_domain && HEADLESS=true AWS_URL=#{args[:url]} cucumber -t @setup-with-ews") do |pipe|
      puts console_output = pipe.read
      pipe.close_write
    end
  end

  desc "Configure your test environment with IMAP"
  task :imap, [:url] do |t, args|
    puts " * Configuring #{args[:url]} with IMAP, this may take a minute... \u2615"
    IO.popen("thor env:dynamic_domain && HEADLESS=true AWS_URL=#{args[:url]} cucumber -t @setup-with-imap") do |pipe|
      puts console_output = pipe.read
      pipe.close_write
    end
  end
end

namespace :upload do
  desc "Upload random eml files to your test environment"
  task :eml_files, [:url] do |t, args|
    puts " * Uploading #{args[:url]} with some test eml files, this may take a minute... \u2615"
    IO.popen("thor env:dynamic_domain && HEADLESS=true AWS_URL=#{args[:url]} cucumber -t @upload-eml-files") do |pipe|
      puts console_output = pipe.read
      pipe.close_write
    end
  end
end

namespace :setup do
  desc "Add all users, integrations, rules, and config EWS in your test environment"
  task :everything, [:url] do |t, args|
    Rake::Task["add:all_users"].invoke(args[:url])
    Rake::Task["add:integrations"].invoke(args[:url])
    Rake::Task["add:rules"].invoke(args[:url])
    Rake::Task["config:ews"].invoke(args[:url])
  end
end