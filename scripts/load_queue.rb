require 'aws-sdk'
require 'json'
require 'env'

require 'models/sequencer'

class QueueLoader

  def initialize(id)
    @sqs_queue = AWS::SQS.new.queues.create(id)
    @sequencer = Sequencer.new(id)
  end

  def run
    sequence_number = @sequencer.last_seen
    loop do
      payload = {
        :results => {
          :con => rand(100),
          :lab => rand(100),
          :lib => rand(5)
        },
        :seq => sequence_number
      }

      msg = @sqs_queue.send_message payload.to_json
      puts "Sent message: #{msg.id} (seq: #{sequence_number})"

      sequence_number += 1
      sleep 1
    end
  end

end

cache_id = "s3-render-example"

t = Thread.new do
  QueueLoader.new(cache_id).run
end

t.join

