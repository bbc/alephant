require 'aws-sdk'

module Alephant
  class Queue
    attr_accessor :q

    def initialize(id)
      @logger = ::Alephant.logger

      @sqs = AWS::SQS.new
      @q = @sqs.queues[id]

      unless @q.exists?
        @q = @sqs.queues.create(id)
        sleep_until_queue_exists
        @logger.info("Queue.initialize: created queue with id #{id}")
      end

      @logger.info("Queue.initialize: ended with id #{id}")
    end

    def sleep_until_queue_exists
      sleep 1 until @q.exists?
    end

    def poll(*args, &block)
      @logger.info("Queue.poll: polling with arguments #{args}")
      @q.poll(*args, &block)
    end
  end
end
