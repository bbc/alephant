$: << "."

require "env"

class App
  def self.message_generator(initial_counter_value = 1663)
    @@counter = initial_counter_value
    p "Counter is now: #{@@counter}"

    configure_queue

    loop do
      send_message
    end

    p "loop broken"
  end

  def self.configure_queue
    queue.visibility_timeout = 120
  end

  def self.send_message
    time = Random.rand(1..5)

    p "Going to sleep for #{time} seconds before sending a message to the queue"

    sleep time # mimic messages coming into queue at random
    queue.send_message(message)

    p "Message sent"
    p "-------------"
  end

  def self.message
    @@counter = @@counter + 1
    p "Sending message sequence: #{@@counter}"
    { :sequence => @@counter, :title => "My Title", :timestamp => Time.now.utc }.to_json
  end

  def self.queue
    @@queue ||= sqs.queues.named(ENV["SQS_QUEUE"])
  end

  def self.sqs
    @@sqs ||= AWS::SQS.new
  end
end

App.message_generator
