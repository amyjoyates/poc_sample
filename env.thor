class Env < Thor
  include Thor::Actions

  no_tasks do
    def copy_environment(new_environment)
      source=File.join("features", "support", "full_stack_configs", "env", "env.rb.#{new_environment}")
      target=File.join("features", "support", "env.rb")

      run("cp #{source} #{target}")
    end
  end

  desc "check_console", "** (store.demoqa.com) Check Chrome Browser Console for Errors**"
  def check_console
    copy_environment("check_console")
  end

  desc "headless", "** (store.demoqa.com) **"
  def headless
    copy_environment("headless")
  end

  desc "firefox", "** (store.demoqa.com) **"
  def firefox
    copy_environment("firefox")
  end

  desc "safari", "** (store.demoqa.com) **"
  def safari
    copy_environment("safari")
  end

  desc "chrome", "** (store.demoqa.com) **"
  def chrome
    copy_environment("chrome")
  end

end
