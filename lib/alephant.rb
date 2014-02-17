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
      data = parse msg

      @render_mapper.generate(data).each do |component_id, renderer|
        location = location_for(component_id, msg)

        @cache.put(location, renderer.render)
        Lookup.create(
          @lookup_table_name,
          component_id
        ).write(data[:options], location)
      end

      @sequencer.set_last_seen(msg)
    end

    def receive(msg)
      write msg if @sequencer.sequential?(msg)
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
      {}.tap { |o| o[:variant] = @jsonpath_lookup.lookup(msg.body) if @jsonpath_lookup }
    end

    def location_for(component_id, msg)
      "#{@renderer_id}_#{component_id}_#{@sequencer.sequence_id_from(msg)}"
    end

    def parse(msg)
      @parser.parse(msg.body).tap { |o| o[:options] = options_for msg }
    end

  end
end
