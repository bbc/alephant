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
require 'alephant/lookup'

module Alephant
  class Alephant
    include ::Alephant::Logger

    attr_reader :sequencer, :queue, :cache, :renderer

    VALID_OPTS = [
      :s3_bucket_id,
      :s3_object_path,
      :sequencer_table_name,
      :lookup_table_name,
      :sqs_queue_url,
      :view_path,
      :renderer_id,
      :sequence_id_path,
      :msg_vary_id_path
    ]

    def initialize(opts = {}, logger = nil)
      ::Alephant::Logger.set_logger(logger) unless logger.nil?
      set_opts(opts)

      @sequencer = Sequencer.create(@sequencer_table_name, @sqs_queue_url, @sequence_id_path)
      @queue = Queue.new(@sqs_queue_url)
      @cache = Cache.new(@s3_bucket_id, @s3_object_path)
      @render_mapper = RenderMapper.new(@renderer_id, @view_path)
      @jsonpath_lookup = @msg_vary_id_path ? JsonPathLookup.new(@msg_vary_id_path) : nil
      @parser = Parser.new
    end

    def write(msg)
      data = @parser.parse msg.body
      @render_mapper.generate(data).each do |component_id, renderer|

        location = location_for(component_id, msg)
        @cache.put(location, renderer.render)
        write_location_for(component_id, location, msg)
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

    def options_for(msg)
      opts = {}
      opts[:variant] = @jsonpath_lookup.lookup(msg.body) if @jsonpath_lookup

      opts
    end

    def write_location_for(component_id, location, msg)
      lookup = Lookup.create(@lookup_table_name, component_id)
      lookup.write(options_for(msg), location)
    end

    def location_for(component_id, msg)
      sequence_id = @sequencer.sequence_id_from(msg)
      "#{@renderer_id}_#{component_id}_#{sequence_id}"
    end

  end
end
