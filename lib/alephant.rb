require_relative 'env'

require 'alephant/models/queue'
require 'alephant/models/multi_renderer'
require 'alephant/models/parser'

require 'alephant/sequencer'
require 'alephant/cache'
require 'alephant/logger'
require 'alephant/errors'
require 'alephant/views'
require 'alephant/renderer'

module Alephant
  class Alephant
    include ::Alephant::Logger

    attr_reader :sequencer, :queue, :cache, :renderer

    VALID_OPTS = [
      :s3_bucket_id,
      :s3_object_path,
      :s3_object_id,
      :table_name,
      :sqs_queue_id,
      :view_path,
      :component_id,
      :sequence_id
    ]

    def initialize(opts = {}, logger = nil)
      ::Alephant::Logger.set_logger(logger) unless logger.nil?
      set_opts(opts)

      @sequencer = Sequencer.create(@table_name, @sqs_queue_id, @sequence_id)
      @queue = Queue.new(@sqs_queue_id)
      @cache = Cache.new(@s3_bucket_id, @s3_object_path)
      @multi_renderer = MultiRenderer.new(@component_id, @view_path)
      @parser = Parser.new
    end

    def write(data)
      @multi_renderer.render(data).each do |id, item|
        @cache.put(id, item)
      end
    end

    def receive(msg)
      logger.info("Alephant.receive: with id #{msg.id} and body digest: #{msg.md5}")

      if @sequencer.sequential?(msg)
        write @parser.parse msg.body
        @sequencer.set_last_seen(msg)
      else
        logger.warn("Alephant.receive: out of sequence message received #{msg.id} (discarded)")
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
