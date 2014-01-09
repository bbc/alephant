Gem::Specification.new do |s|
  s.name        = 'alephant'
  s.version     = '0.0.2'
  s.date        = '2014-01-08'
  s.summary     = "Static Publishing in the Cloud"
  s.description = "Static publishing to S3 based on SQS messages"
  s.authors     = ["Robert Kenny"]
  s.email       = 'kenoir@gmail.com'
  s.files       = `git ls-files`.split("\n")
  s.platform    = "java"
  s.homepage    =
    'http://rubygems.org/gems/alephant'
  s.license     = 'GPLv3'
  s.require_paths = ["lib"]

  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
  s.add_development_dependency "pry"

  s.add_runtime_dependency 'aws-sdk', '~> 1.0'
  s.add_runtime_dependency 'mustache', '>= 0.99.5'
end
