require 'crimp'
require 'alephant/broker/load_strategy/http'

module Broker
  class DynamicUrlLocator < Alephant::Broker::LoadStrategy::HTTP::URL
    def initialize(config)
      @config = config
      @dynamo = AWS::DynamoDB::Client::V20120810.new
    end

    def generate(component_id, options)
      "#{location_from query(options)}/component/#{component_id}"
    end

    private

    attr_reader :config, :dynamo

    def dynamo_table_name
      config[:dynamo_table_name]
    end

    def routing_from(options)
      Crimp.signature(
        options[:routing] || {}
      )
    end

    def location_from(results)
      results[:count] == 1 ? results[:member].first['location'][:s]
                           : raise(Broker::DynamicUrlLocator::NotFound)
    end

    def query(options)
      dynamo.query query_options(
        routing_from(options)
      )
    end

    def query_options(opts_hash)
      {
        :attributes_to_get => [
          'location'
        ],
        :key_conditions => {
          'opts_hash' => {
            :attribute_value_list => [
              { 's' => opts_hash }
            ],
            :comparison_operator => 'EQ'
          }
        },
        :limit => 1,
        :table_name => dynamo_table_name
      }
    end

    class NotFound < Exception; end
  end
end
