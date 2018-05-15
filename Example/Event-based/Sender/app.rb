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

  def random
    Random.rand(1..5)
  end

  def send(msg)
    client.send_message(
      queue_url:    queue_url,
      message_body: msg
    )

    logger.info 'Message sent'
  end

  def delay
    random.tap do |time|
      logger.info "Going to sleep for #{time}s before sending a message to the queue"
      sleep time
    end
  end

  def client
    options = {}
    options[:endpoint] = ENV['AWS_SQS_ENDPOINT'] if ENV['AWS_SQS_ENDPOINT']
    @client ||= Aws::SQS::Client.new(options)
  end

  def queue_url
    options = {
      queue_name: ENV['SQS_QUEUE_NAME']
    }

    client.get_queue_url(options).queue_url
  end
end

Sender.new.generate_messages!
