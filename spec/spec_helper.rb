$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'rain_table'

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = [:should, :expect]
  end
end
