require_relative 'env'

require 'alephant/models/render_mapper'
require 'alephant/support/parser'
require 'alephant/models/writer'
require 'alephant/models/queue'

require 'alephant/sequencer'
require 'alephant/cache'
require 'alephant/logger'
require 'alephant/views'
require 'alephant/renderer'
require 'alephant/lookup'

module Alephant
  class Alephant
    include ::Alephant::Logger

    attr_reader :sequencer, :queue, :writer, :parser

    def initialize(opts = {}, logger = nil)
      ::Alephant::Logger.set_logger(logger) unless logger.nil?

      @parser = Support::Parser.new(
        opts[:msg_vary_id_path]
      )
      @sequencer = Sequencer.create(
        opts[:sequencer_table_name],
        opts[:sqs_queue_url],
        opts[:sequence_id_path]
      )
      @queue = Queue.new(
        opts[:sqs_queue_url]
      )
      @writer = Writer.new(
        opts.select do |k,v|
          [
            :renderer_id,
            :s3_bucket_id,
            :s3_object_path,
            :view_path,
            :lookup_table_name
          ].include? k
        end
      )
    end

    def run!
      Thread.new do
        @queue.poll { |msg| receive(msg) }
      end
    end

    def receive(msg)
      write msg if sequencer.sequential?(msg)
    end

    private
    def write(msg)
      writer.write(parser.parse(msg), sequencer.sequence_id_from(msg))
      sequencer.set_last_seen(msg)
    end

  end
end
