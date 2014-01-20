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
  class Alephant
    attr_reader :sequencer, :queue, :cache, :renderer

    VALID_OPTS = [
      :s3_bucket_id,
      :s3_object_path,
      :s3_object_id,
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
      @cache = Cache.new(@s3_bucket_id, @s3_object_path)
      @renderer = Renderer.new(@view_id)
    end

    def parse(msg)
      JSON.parse(msg)
    end

    def write(data)
      @cache.put(
        @s3_object_id,
        @renderer.render(data)
      )
    end

    def receive(msg)
      data = parse(msg.body)

      if @sequencer.sequential?(data, &@sequential_proc)
        write data
        @sequencer.set_last_seen(data, &@set_last_seen_proc)
      end
    end

    def run!
      Thread.new do
        @queue.poll { |msg| receive(msg) }
      end
    end

    private
    def set_opts(opts)
      VALID_OPTS.each do | k |
        v = opts.has_key?(k) ? opts[k] : nil
        singleton_class.class_eval do
          attr_accessor k
        end
        send("#{k}=", v)
      end
    end

  end
end
