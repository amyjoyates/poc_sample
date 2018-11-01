class Search
  include PageObject

  def search_field(value)
    @browser.first(:class,'search').send_keys(value)
  end


end
