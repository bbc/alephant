require 'aws-sdk'
require 'yaml'

config_file = File.join("config", "aws.yml")

if File.exists? config_file
  config = YAML.load(File.read(config_file))
  AWS.config(config)
end

