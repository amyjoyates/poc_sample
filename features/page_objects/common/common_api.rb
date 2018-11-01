class CommonApi
  include PageObject
  require 'httparty'
  require 'uri'
  require 'httparty/parser'

  def authenticate(domain)
    puts "***** Depricated Method - Please Delete me ;) ******"
  end

  def check_token_expiration(domain)
    puts "***** Depricated Method - Please Delete me ;) ******"
  end

  def api_response_status_check(value, response)
    puts("\u0009** #{value}")
    error = "\u0009** ERROR when " + value.to_s + " response -> "
    raise error + response.to_s unless response.code == 200
  end
end
