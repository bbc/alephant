require 'rubygems'
require 'yaml'
require 'aws-sdk'

config_file = File.join(File.dirname(__FILE__), "config.yml")
config = YAML.load(File.read(config_file))
AWS.config(config)

sqs = AWS::SQS.new
queue = sqs.queues.create("s3-render-example")

(1..100).each do | i |
  msg = queue.send_message("HELLO #{i}")
  puts "Sent message: #{msg.id}"
end

