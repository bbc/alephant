# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'alephant/version'

Gem::Specification.new do |spec|
  spec.name          = "alephant"
  spec.version       = Alephant::VERSION
  spec.authors       = ["Integralist"]
  spec.email         = ["mark.mcdx@gmail.com"]
  spec.summary       = "Alephant framework"
  spec.description   = "Alephant framework"
  spec.homepage      = "https://github.com/BBC-News/alephant"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"

  spec.add_runtime_dependency 'alephant-publisher'
  spec.add_runtime_dependency 'alephant-support'
  spec.add_runtime_dependency 'alephant-sequencer'
  spec.add_runtime_dependency 'alephant-cache'
  spec.add_runtime_dependency 'alephant-logger'
  spec.add_runtime_dependency 'alephant-renderer'
  spec.add_runtime_dependency 'alephant-lookup'
  spec.add_runtime_dependency 'alephant-preview'
end
