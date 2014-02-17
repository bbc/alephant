require_relative 'env'

require 'alephant/models/render_mapper'
require 'alephant/models/jsonpath_lookup'
require 'alephant/models/queue'
require 'alephant/models/parser'

require 'alephant/sequencer'
require 'alephant/cache'
require 'alephant/logger'
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
      :sequence_id_path,
      :msg_vary_id_path
    ]

    def initialize(opts = {}, logger = nil)
      ::Alephant::Logger.set_logger(logger) unless logger.nil?
      set_opts(opts)

      @sequencer = Sequencer.create(@table_name, @sqs_queue_id, @sequence_id_path)
      @queue = Queue.new(@sqs_queue_id)
      @cache = Cache.new(@s3_bucket_id, @s3_object_path)
      @render_mapper = RenderMapper.new(@component_id, @view_path)
      @jsonpath_lookup = @msg_vary_id_path ? JsonPathLookup.new(@msg_vary_id_path) : nil
      @parser = Parser.new
    end

    def write(msg)
      data = @parser.parse msg.body
      @render_mapper.generate(data).each do |id, renderer|
        vary_on = @jsonpath_lookup ? @jsonpath_lookup.lookup(msg) : nil
        # alephant-lookup goes here!
        @cache.put(id, renderer.render)
      end
    end

    def receive(msg)
      logger.info("Alephant.receive: with id #{msg.id} and body digest: #{msg.md5}")

      if @sequencer.sequential?(msg)
        write msg
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
