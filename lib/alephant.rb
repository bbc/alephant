require 'aws-sdk'
require 'env'
require 'json'

require 'alephant/models'
require 'alephant/errors'

module Alephant

  def self.run(cache_id)
    queue = AWS::SQS.new.queues.create(cache_id)
    cache = Cache.new(cache_id)
    sequencer = Sequencer.new(cache_id)
    renderer = Renderer.new(cache_id)

    thread = Thread.new do
      puts "Polling queue..."
      queue.poll do |msg|
        data = JSON.parse(msg.body)

        if data["seq"] > sequencer.last_seen
          puts "Rendering from message #{data["seq"]}"

          content = renderer.render(data)
          cache.put(cache_id, content)
          sequencer.last_seen = data["seq"]
        end
      end
    end

    thread
  end
end

