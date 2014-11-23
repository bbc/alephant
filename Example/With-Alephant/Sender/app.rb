$: << "."

require "env"

class App
  def self.message_generator(initial_counter_value = 1)
    @@counter = initial_counter_value
    p "Counter is now: #{@@counter}"

    set_components
    configure_queue

    loop do
      send_message
      break if @@components.empty?
    end

    p "loop broken"
    message_generator(@@counter + 1)
  end

  def self.set_components
    @@components = ["test", "foo", "bar"]
  end

  def self.configure_queue
    queue.visibility_timeout = 120
  end

  def self.send_message
    time = Random.rand(1..5)

    p "Going to sleep for #{time} seconds before sending a message to the queue"

    sleep time # mimic messages coming into queue at random
    queue.send_message(message) unless @@components.empty?

    p "Message sent"
    p "-------------"
  end

  def self.message
    { :sequence => @@counter, :component => component, :title => "My Title", :timestamp => Time.now.utc }.to_json
  end

  def self.component
    @@components.shift

    # we wouldn't do this in a real application
    # this code just makes it easier for us to
    # render (theorectically) different templates
  end

  def self.queue
    @@queue ||= sqs.queues.named(ENV["SQS_QUEUE"])
  end

  def self.sqs
    @@sqs ||= AWS::SQS.new
  end
end

App.message_generator
