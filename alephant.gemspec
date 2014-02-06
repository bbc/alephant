# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'alephant/version'

Gem::Specification.new do |s|
  s.name          = 'alephant'
  s.version       = Alephant::VERSION
  s.date          = Time.now.strftime "%Y-%m-%d"
  s.summary       = "Static Publishing in the Cloud"
  s.description   = "Static publishing to S3 based on SQS messages"
  s.authors       = ["Robert Kenny"]
  s.email         = 'kenoir@gmail.com'
  s.license       = 'GPLv3'

  s.files         = `git ls-files`.split($/)
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.platform      = "java"
  s.homepage      = 'https://github.com/BBC-News/alephant'
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]

  s.add_development_dependency "rspec"
  s.add_development_dependency "rspec-nc"
  s.add_development_dependency "guard"
  s.add_development_dependency "guard-rspec"
  s.add_development_dependency "pry"
  s.add_development_dependency "pry-remote"
  s.add_development_dependency "pry-nav"

  s.add_runtime_dependency 'sinatra'
  s.add_runtime_dependency 'faraday'
  s.add_runtime_dependency 'trollop'
  s.add_runtime_dependency 'rake'
  s.add_runtime_dependency 'aws-sdk', '~> 1.0'
  s.add_runtime_dependency 'mustache', '>= 0.99.5'
  s.add_runtime_dependency 'jsonpath'
end

