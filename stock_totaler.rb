require 'json'
require 'faraday'

class SymbolNotFound < StandardError; end
class RequestFailed < StandardError; end

class MarkitClient
  attr_reader :http_client

  def initialize(http_client=Faraday.new)
    @http_client = http_client
  end

  def last_price(stock_symbol)
    url = 'http://dev.markitondemand.com/MODApis/Api/v2/Quote/json'
    data = make_request(url, symbol: stock_symbol)
    price = data['LastPrice']

    raise SymbolNotFound.new(data['Message']) unless price

    price
  end

  private

  def make_request(url, params={})
    begin
      response = http_client.get(url, params)
      JSON.load(response.body)
    rescue Faraday::Error::ConnectionFailed => e
      raise RequestFailed.new(e.message)
    end
  end
end

def calculate_value(symbol, quantity)
  markit_client = MarkitClient.new
  price = markit_client.last_price(symbol)
  price * quantity.to_i
end

if $0 == __FILE__
  symbol, quantity = ARGV
  puts calculate_value(symbol, quantity)
end
