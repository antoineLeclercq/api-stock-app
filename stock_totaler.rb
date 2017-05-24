require 'json'
require 'faraday'

def calculate_value(symbol, quantity)
  url = 'http://dev.markitondemand.com/MODApis/Api/v2/Quote/json'

  http_client = Faraday.new

  response = http_client.get(url, symbol: symbol)
  data = JSON.load(response.body)

  price = data['LastPrice']
  price.to_f * quantity.to_i
end

symbol, quantity = ARGV
puts calculate_value(symbol, quantity) if $0 == __FILE__
