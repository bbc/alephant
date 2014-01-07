$: << File.dirname(__FILE__)

require 'aws-sdk'
require 'yaml'
require 'pry'

config_file = File.join(File.dirname(__FILE__), "config", "aws.yml")
config = YAML.load(File.read(config_file))
AWS.config(config)
