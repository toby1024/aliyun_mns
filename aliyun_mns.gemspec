# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'aliyun_mns/version'

Gem::Specification.new do |spec|
  spec.name          = "aliyun_mns"
  spec.version       = AliyunMns::VERSION
  spec.authors       = ["jason"]
  spec.email         = ["zhangbin.zj@gmail.com"]

  spec.summary       = "aliyun mns http api"
  spec.description   = "aliyun mns http api for topic"
  spec.homepage      = "https://github.com/zhangbin/aliyun_mns.git"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    # spec.metadata['allowed_push_host'] = "http://mygemserver.com"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'nokogiri', '>= 1.6'
  spec.add_dependency 'activesupport', '>= 4.1'
  spec.add_dependency "rest-client", '>= 1.8.0'


  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
