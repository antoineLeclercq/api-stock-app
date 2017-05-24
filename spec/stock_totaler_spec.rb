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
    expect(total_value).to eq(303.86)
  end
end
