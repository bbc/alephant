require 'aws-sdk'
require 'json'

class QueueLoader

  def initialize(id)
    @sqs_queue = AWS::SQS.new.queues.create(id)
  end

  def run
    sequence_number = 0
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
      puts "Sent message: #{msg.id}"

      sequence_number += 1
      sleep 1
    end
  end

end

