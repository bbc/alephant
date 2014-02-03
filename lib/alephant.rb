require 'aws-sdk'
require 'json'

require_relative 'env'

require 'alephant/models/logger'
require 'alephant/models/queue'
require 'alephant/models/cache'
require 'alephant/models/renderer'
require 'alephant/models/multi_renderer'
require 'alephant/models/sequencer'

require 'alephant/errors'
require 'alephant/views'

module Alephant
  class Alephant
    attr_reader :sequencer, :queue, :cache, :renderer

    VALID_OPTS = [
      :model_file,
      :s3_bucket_id,
      :s3_object_path,
      :s3_object_id,
      :table_name,
      :sqs_queue_id,
      :view_id,
      :view_path,
      :sequential_proc,
      :set_last_seen_proc
    ]

    def initialize(opts = {}, logger = nil)
      set_logger(logger)
      set_opts(opts)

      @logger = ::Alephant.logger
      @sequencer = Sequencer.new(
        {
          :table_name => @table_name
        },
        @sqs_queue_id
      )

      @queue = Queue.new(@sqs_queue_id)
      @cache = Cache.new(@s3_bucket_id, @s3_object_path)
      @multi_renderer = MultiRenderer.new(@model_file, @view_path)
    end

    def set_logger(logger)
      ::Alephant.logger = logger
    end

    def parse(msg)
      JSON.parse(msg, :symbolize_names => true)
    end

    def write(data)
      @multi_renderer.render(data).each do |id, item|
        @cache.put(id, item)
      end
    end

    def receive(msg)
      data = parse(msg.body)

      @logger.info("Alephant.receive: with id #{msg.id} and body digest: #{msg.md5}")

      if @sequencer.sequential?(data, &@sequential_proc)
        write data
        @sequencer.set_last_seen(data, &@set_last_seen_proc)
      else
        @logger.warn("Alephant.receive: out of sequence message received #{msg.id} (discarded)")
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
