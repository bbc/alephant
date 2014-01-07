require 'aws-sdk'
require 'env'
require 'json'
require 'models/cacher'
require 'models/renderer'

cache_id = "s3-render-example"

queue = AWS::SQS.new.queues.create(cache_id)
cache = Cacher.new(cache_id)
renderer = Renderer.new

t = Thread.new do
  queue.poll do |msg|
    puts "Got message: #{msg.id}"
    data = JSON.parse(msg.body)
    content = renderer.render(cache_id, data["results"])

    cache.put("example", content)
  end
end

t.join

