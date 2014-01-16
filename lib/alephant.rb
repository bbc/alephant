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
    attr_accessor :queue, :cache, :sequencer, :renderer
    attr_accessor :s3_bucket_id, :s3_object_path, :table_name, :sqs_queue_id, :view_id

    def initialize(opts = {})
      opts.each { |k,v| instance_variable_set("@#{k}",v) }

      @sequencer ||= Sequencer.new(
        {
          :table_name => @table_name
        },
        @sqs_queue_id
      )

      @queue ||= Queue.new(@sqs_queue_id)
      @cache ||= Cache.new(@s3_bucket_id)
      @renderer ||= Renderer.new(@view_id)
    end

    def run!(sequential_proc = nil, set_last_seen_proc = nil)
      Thread.new do
        @queue.poll do |msg|
          data = JSON.parse(msg.body)

          if @sequencer.sequential?(data, &sequential_proc)
            @cache.put(
              @s3_object_path,
              @renderer.render(data)
            )
            @sequencer.set_last_seen(data, &set_last_seen_proc)
          end
        end
      end
    end
  end
end
