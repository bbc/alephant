require 'aws-sdk'

module Alephant
  class Queue
    attr_accessor :queue

    def initialize(id)
      @sqs = AWS::SQS.new
      @q = @sqs.queues[id].exists?
      sqs.queues
      @queue = AWS::SQS.new.queues.create(id)
    end

    def sleep_until_queue_exists
      sleep 1 until @q.exists?
    end

    def poll(*args, &block)
      @q.poll(*args, &block)
    end
  end
end
