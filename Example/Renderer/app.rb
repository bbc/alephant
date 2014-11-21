$: << "."

require "env"
require "mustache"
require "crimp"

class App
  def self.poll_queue
    queue.poll do |msg|
      data = parse msg.body
      bucket.objects[create_key_from data].write(render data)
    end
  end

  def self.queue
    @@queue ||= sqs.queues.named(ENV["SQS_QUEUE"])
  end

  def self.sqs
    @@sqs ||= AWS::SQS.new
  end

  def self.render(data)
    Mustache.render template, data
  end

  def self.template
    @@template ||= IO.read "templates/test.mustache"
  end

  def self.parse(data)
    JSON.parse data, :symbolize_names => true
  end

  def self.s3
    @@s3 ||= AWS::S3.new
  end

  def self.bucket
    @@bucket ||= s3.buckets[ENV["S3_BUCKET"]]
  end

  def self.create_key_from(data)
    Crimp.signature data
  end
end

App.poll_queue
