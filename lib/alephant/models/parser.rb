require 'json'

module Alephant
  class Parser
    attr_reader :vary_lookup

    def initialize(vary_jsonpath = nil)
      @vary_lookup = vary_jsonpath ? JsonPathLookup.new(vary_jsonpath) : nil
    end

    def parse(msg)
      symbolize(msg.body).tap { |o| o[:options] = options_for msg }
    end

    private
    def symbolize(data)
      JSON.parse(data, :symbolize_names => true)
    end

    def options_for(msg)
      {}.tap do |o|
        o[:variant] = vary_lookup.lookup(msg.body) if not vary_lookup.nil?
      end
    end
  end
end

