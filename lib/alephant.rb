$: << File.dirname(__FILE__)

require 'aws-sdk'
require 'json'

require_relative 'env'

require 'alephant/models/cache'
require 'alephant/models/renderer'
require 'alephant/models/sequencer'

require 'alephant/errors'
require 'alephant/views'

module Alephant
  class AlephantRunner
    attr_reader :queue, :cache, :sequencer, :renderer, :cache_path

    def initialize(opts = {})
      opts.each { |k,v| instance_variable_set("@#{k}",v) }
    end

    def run!
      #queue = AWS::SQS.new.queues.create(cache_id)
      #cache = Cache.new(cache_id,cache_id)
      #sequencer = Sequencer.new(cache_id)
      #renderer = Renderer.new(cache_id)

      Thread.new do
        @queue.poll do |msg|
          data = JSON.parse(msg.body)
          current = @sequencer.sequence(data)
          if current > @sequencer.last_seen
            content = @renderer.render(data)
            @cache.put(@cache_path, content)
            @sequencer.last_seen = current
          end
        end
      end
    end
  end
end
