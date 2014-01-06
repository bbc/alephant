require 'rubygems'
require 'yaml'
require 'aws-sdk'

config_file = File.join(File.dirname(__FILE__), "config.yml")
config = YAML.load(File.read(config_file))
AWS.config(config)

sqs = AWS::SQS.new
queue = sqs.queues.create("s3-render-example")

thread = Thread.new do
  queue.poll do |msg|
    puts "Got message: #{msg.body}"
  end
end

thread.join

