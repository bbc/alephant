require 'aws-sdk'
require 'yaml'

config_file = File.join(File.dirname(__FILE__), "..", "config", "aws.yml")
config = YAML.load(File.read(config_file))
AWS.config(config)

