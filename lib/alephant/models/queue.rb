require 'aws-sdk'

module Alephant
  class Queue
    attr_accessor :q

    def initialize(id)
      @sqs = AWS::SQS.new
      @q = @sqs.queues[id]

      unless @q.exists?
        @q = @sqs.queues.create(id)
        sleep_until_queue_exists
      end
    end

    def sleep_until_queue_exists
      sleep 1 until @q.exists?
    end

    def poll(*args, &block)
      @q.poll(*args, &block)
    end
  end
end
