class Homepage
  include PageObject
  
  def home_button
    @browser.first(:class,'menu-item-home')
  end
end
