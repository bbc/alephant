$LOAD_PATH << File.dirname(__FILE__)

require 'aws-sdk'
require 'yaml'

require 'alephant/util/string'

config_file = File.join('config', 'aws.yaml')

if File.exists? config_file
  config = YAML.load(File.read(config_file))
  AWS.config(config)
end

