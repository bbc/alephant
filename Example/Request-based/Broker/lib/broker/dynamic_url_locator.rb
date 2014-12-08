require 'crimp'
require 'alephant/broker/load_strategy/http'

module Broker
  class DynamicUrlLocator < Alephant::Broker::LoadStrategy::HTTP::URL
    def initialize(config)
      @config = config
      @dynamo = AWS::DynamoDB::Client::V20120810.new
    end

    def generate(component_id, options)
      location_from query(component_id, options)
    end

    private

    attr_reader :config, :dynamo

    def dynamo_table_name
      config[:dynamo_table_name]
    end

    def location_from(results)
      results[:count] == 1 ? results[:member].first['location'][:s]
                           : 'http://google.com'
    end

    def query(component_id, options)
      dynamo.query query_options(
        component_id,
        Crimp.signature(options)
      )
    end

    def query_options(component_id, opts_hash)
      {
        :attributes_to_get => [
          'location'
        ],
        :key_conditions => {
          'component_id' => {
            :attribute_value_list => [
              { 's' => opts_hash }
            ],
            :comparison_operator => 'EQ'
          },
          'opts_hash' => {
            :attribute_value_list => [
              { 's' => component_id }
            ],
            :comparison_operator => 'EQ'
          }
        },
        :limit => 1,
        :select => 'SPECIFIC_ATTRIBUTES',
        :table_name => dynamo_table_name
      }
    end
  end
end
