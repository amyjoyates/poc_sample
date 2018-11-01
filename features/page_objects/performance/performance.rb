class Performance
  include PageObject

  def check_page_performance(milliseconds, domain)
    require 'slack-notifier'
    notifier = Slack::Notifier.new "https://hooks.slack.com/services/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", channel: 't2_perf_notifications', username: 'T2TestBot'
    require 'mail'
    recipients = ["rich.downie@phishme.com"]
    Selenium::WebDriver::Wait.new(:timeout => 15).until {@browser.find_element(class: 'cluster-summary').displayed?}
    @browser.first(class: 'debug-view__tab').click
    @browser.all(class: 'debug-item').each do |summary|
      timing = summary.first(class: 'request-summary__time').text.gsub!(/ms/, '').to_i
      if timing > milliseconds.to_i
        notifier.ping "\u2757 Check DEBUG \u2757 on #{domain}"
        puts summary = "\u2757 " + summary.first(class: 'debug-item__request-summary').text.to_s + " \u2757"
        notifier.ping "#{summary}"
        # recipients.each do |recipient|
 #          mail = Mail.new do
 #            from     "rich.downie@phishme.com"
 #            to       recipient
 #            subject  "T2 Poor Performance"
 #            git_branch = IO.popen("git symbolic-ref --short HEAD") {|pipe| @git_branch = pipe.read.chomp }
 #            html_part do
 #               content_type 'text/html; charset=UTF-8'
 #               body "<p><b>Poor Application performance:</b> #{domain}</p>
 #                     <p><b>Summary:</b> #{summary}</p>
 #                     <p><b>Git Branch:</b> #{git_branch}</p>"
 #             end
 #          end
 #          Mail.defaults do
 #            delivery_method :smtp, address: "phishme-com.mail.protection.outlook.com", port: 25
 #            mail.deliver
 #          end
 #        end
      end
    end
    @browser.first(class: 'debug-view__tab').click
  end
end
