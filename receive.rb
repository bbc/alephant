require 'rubygems'
require 'yaml'

require 'config'
require 'models/s3_cache'

require 'aws-sdk'

config_file = File.join(File.dirname(__FILE__), "config.yml")
config = YAML.load(File.read(config_file))
AWS.config(config)

cache_id = "s3-render-example"

queue = AWS::SQS.new.queues.create(cache_id)
cache = S3Cache.new(cache_id)

thread = Thread.new do
  queue.poll do |msg|
    puts "Got message: #{msg.body}"
    cache.put("example",msg.body)
  end
end

thread.join

