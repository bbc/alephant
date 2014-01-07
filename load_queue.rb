require 'aws-sdk'
require 'env'
require 'pry'

require 'models/queue_loader'

cache_id = "s3-render-example"

# Start loading queue
t = Thread.new do
  QueueLoader.new(cache_id).run
end

t.join

