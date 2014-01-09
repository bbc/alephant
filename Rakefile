$:.unshift File.join(File.dirname(__FILE__), 'lib')

require 'rspec/core/rake_task'
require 'alephant'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec
