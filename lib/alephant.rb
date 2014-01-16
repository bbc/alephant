$: << File.dirname(__FILE__)

require 'aws-sdk'
require 'json'

require_relative 'env'

require 'alephant/models/queue'
require 'alephant/models/cache'
require 'alephant/models/renderer'
require 'alephant/models/sequencer'

require 'alephant/errors'
require 'alephant/views'

module Alephant
  class AlephantRunner
    VALID_OPTS = [
      :s3_bucket_id,
      :s3_object_path,
      :table_name,
      :sqs_queue_id,
      :view_id,
      :sequential_proc,
      :set_last_seen_proc
    ]

    def initialize(opts = {})
      set_opts(opts)

      @sequencer = Sequencer.new(
        {
          :table_name => @table_name
        },
        @sqs_queue_id
      )

      @queue = Queue.new(@sqs_queue_id)
      @cache = Cache.new(@s3_bucket_id)
      @renderer = Renderer.new(@view_id)
    end

    def run!
      Thread.new do
        @queue.poll do |msg|
          data = JSON.parse(msg.body)

          if @sequencer.sequential?(data, &@sequential_proc)
            @cache.put(
              @s3_object_path,
              @renderer.render(data)
            )
            @sequencer.set_last_seen(data, &@set_last_seen_proc)
          end
        end
      end
    end

    private
    def set_opts(opts)
      VALID_OPTS.each do | k |
        v = opts.has_key? opt ? opts[k] : nil
        singleton_class.class_eval do
          attr_accessor opt
        end
        send("#{k}=", v)
      end
    end

  end
end
