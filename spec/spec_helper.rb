require 'rspec'
require "codeclimate-test-reporter"
CodeClimate::TestReporter.start
require 'aliyun_mns'

Dir[File.join(File.dirname(__FILE__), "../spec/support/**/*.rb")].sort.each { |f| require f }
RSpec.configure do |config|
  config.color = true
  config.mock_with :rspec
end

AliyunMns.configure do |config|

  config.access_key_id = "access_key_id"
  config.access_key_secret = "access_key_secret"
  config.endpoint = "$id.mns.cn-hangzhou.aliyuncs.com"
end