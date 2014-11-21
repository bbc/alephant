class App
  def self.call(env)
    message_generator

    [200, {"Content-Type" => "text/plain"}, ["OK"]]
  rescue => exception
    [500, {"Content-Type" => "text/plain"}, ["#{exception.backtrace}"]]
  end

  private

  def self.message_generator
    configure_queue
    send_message
  end

  def self.configure_queue
    queue.visibility_timeout = 120
  end

  def self.send_message
    time = Random.rand(10..30)
    p "Going to sleep for #{time} seconds before sending a message to the queue"
    sleep time # mimic messages coming into queue at random
    queue.send_message(message)
  end

  def self.message
    { :foo => "bar", :timestamp => Time.now.utc }.to_json
  end

  def self.queue
    @@queue ||= sqs.queues.named(ENV["SQS_QUEUE"])
  end

  def self.sqs
    @@sqs ||= AWS::SQS.new
  end
end
