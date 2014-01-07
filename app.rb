require 'aws-sdk'
require 'env'
require 'json'

require 'models/cacher'
require 'models/renderer'
require 'models/sequencer'

cache_id = "s3-render-example"

queue = AWS::SQS.new.queues.create(cache_id)
cache = Cacher.new(cache_id)
sequencer = Sequencer.new(cache_id)
renderer = Renderer.new(cache_id)

t = Thread.new do
  queue.poll do |msg|
    puts "Got message: #{msg.id}"
    data = JSON.parse(msg.body)

    if data["seq"] > sequencer.last_seen
      content = renderer.render(data)
      cache.put("example", content)
      sequencer.last_seen = data["seq"]
    else
      puts "MESSAGE RECEIVED OUT OF ORDER (data['seq']: #{data["seq"]} <= sequencer.last_seen: #{sequencer.last_seen}): DISCARDING DATA"
    end
  end
end

t.join

