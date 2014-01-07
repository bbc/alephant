require 'aws-sdk'
require 'pry'

config_file = File.join(File.dirname(__FILE__), "config.yml")
config = YAML.load(File.read(config_file))
AWS.config(config)

