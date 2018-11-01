class Common
  include PageObject

  def confirm_modal_yes
    Selenium::WebDriver::Wait.new(:timeout => 3).until {@browser.first(:class,'modal-action--confirm').displayed?}
    @browser.first(:class,'modal-action--confirm')
  end

  def confirm_modal_no
    @browser.first(:class,'modal-action--cancel')
  end

  def close_toast
    @browser.first(:class,'vue-toast_close-btn')
  end

  def take_me_back
    @browser.first(:class, 'page-not-found__button')
  end

  def get_modal
    @browser.first(:class, 'modal-wrapper')
  end

  def close_preview
    @browser.first(:class, 'close-button__icon')
  end

  def get_modal_title
    wait_until do
      !@browser.first(:class, 'title').text.empty?
    end

    @browser.first(:class, 'title')
  end

  def get_modal_body
    wait_until do
      !@browser.first(:class, 'modal-body').text.empty?
    end

    @browser.first(:class, 'modal-body')
  end

  def nav_search
    browser.first(class: "site-header").first(class: "search").first(class: "search__field-wrapper").first(class: "search__field")
  end

  def index_search
    browser.first(class: "index-header__search").first(class: "search").first(class: "search__field-wrapper").first(class: "search__field")
  end

  def index_count()
    @browser.first(class: 'index-header__count').text
  end

  def scroll_to_element(element)
    @browser.execute_script("arguments[0].scrollIntoView(true);",element)
  end

  def resize_window (width, height)
    @browser.manage.window.resize_to(width, height)
  end
end
