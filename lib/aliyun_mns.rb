require 'active_support'
require 'active_support/core_ext'
require 'rest-client'
require 'nokogiri'
require 'yaml'
require 'openssl'
require "aliyun_mns/version"
class Hash
  def self.xml_array content, *path
    o = xml_object(content, *path)
    return (o.is_a?(Array) ? o : [o]).reject { |n| n.empty? }
  end

  def self.xml_object content, *path
    h = from_xml(content)
    path.reduce(h) { |memo, node| memo = memo[node] || {} }
  end
end
module AliyunMns
  require 'aliyun_mns/request'

  class << self
    def configuration
      @configuration ||= begin
        if defined? Rails
          config_file = Rails.root.join("config/aliyun_mns.yml")
        else
          # config_file = File.expand_path("config/aliyun_mns.yml")
          config_file = File.expand_path('../../config/aliyun_mns.yml',  __FILE__)
        end

        if (File.exist?(config_file))
          config = YAML.load(ERB.new(File.new(config_file).read).result)
          config = config[Rails.env] if defined? Rails
        end
        OpenStruct.new(config || {access_id: "", key: "", region: "", owner_id: ""})
      end
    end

    def configure
      yield(configuration)
    end
  end
end
