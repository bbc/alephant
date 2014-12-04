$: << "."

require "env"
require "json"
require "alephant/logger"

class Sender
  include Alephant::Logger

  def initialize(sequence = 1)
    @sequence = sequence
    logger.info "Starting sequence: #{@sequence}"
  end

  def generate_messages!
    loop do
      logger.info "Sending message sequence: #{@sequence}"
      delay
      send message
      increment_sequence
    end
    p 'Loop broken'
  end

  private

  def increment_sequence
    @sequence += 1
  end

  def message
    {
      :sequence  => @sequence,
      :title     => 'Test Message',
      :timestamp => Time.now.utc
    }.to_json
  end

  def queue
    @queue ||= sqs.queues.named(ENV['SQS_QUEUE_NAME']).tap do |q|
      q.visibility_timeout = 120
    end
  end

  def random
    Random.rand(1..5)
  end

  def send(msg)
    queue.send_message msg
    logger.info 'Message sent'
  end

  def delay
    random.tap do |time|
      logger.info "Going to sleep for #{time}s before sending a message to the queue"
      sleep time
    end
  end

  def sqs
    @sqs ||= AWS::SQS.new
  end
end

Sender.new.generate_messages!
