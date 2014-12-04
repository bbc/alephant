require 'crimp'
require 'alephant/broker/load_strategy/http'

module Broker
  class DynamicUrlLocator < Alephant::Broker::LoadStrategy::HTTP::URL
    def initialize(config)
      @config = config
      @dynamo = AWS::DynamoDB::Client.new
    end

    def generate(component, options)
      dynamo.query options(
        component.id,
        Crimp.signature(options)
      )
    end

    private

    attr_reader :config, :dynamo

    def dynamo_table_name
      config[:dynamo_table_name]
    end

    def query_options(component_id, opts_hash)
      {
        :attributes_to_get => [
          'location'
        ],
        :range_key_condition => {
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
