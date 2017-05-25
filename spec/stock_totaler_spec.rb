require_relative '../stock_totaler'

require 'webmock/rspec'
require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/cassettes'
  config.hook_into :webmock
  config.configure_rspec_metadata!
  config.allow_http_connections_when_no_cassette = true
end

RSpec.describe 'stock totaler' do
  it 'calculates stock share value', :vcr do
    total_value  = calculate_value('TSLA', 1)
    expect(total_value).to eq(310.22)
  end

  it 'raises an exception if the symbol does not exist', :vcr do
    expect { calculate_value('ZZZZZZ', 1) }.to raise_error(SymbolNotFound, /No symbol matches/)
  end

  it "handles an exception from Faraday" do
    stub_request(:get, "http://dev.markitondemand.com/MODApis/Api/v2/Quote/json?symbol=ZZZZ").to_timeout

    expect { calculate_value("ZZZZ", 1) }.to raise_error(RequestFailed, /execution expired/)
  end
end
