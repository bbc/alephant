require 'alephant/broker/load_strategy/http'
require 'crimp'
require 'rack'

module Broker
  class DynamicUrlLocator < Alephant::Broker::LoadStrategy::HTTP::URL
    def initialize(config)
      @config = config
      @dynamo = Aws::DynamoDB::Client.new
    end

    def generate(comp_id, opts)
      "#{location_from query(opts)}/component/#{comp_id}?#{parameterize opts}"
    end

    private

    attr_reader :config, :dynamo

    def dynamo_table_name
      config[:dynamo_table_name]
    end

    def location_from(results)
      results.count == 1 ? results.items.first['location']
                           : raise(Broker::DynamicUrlLocator::NotFound)
    end

    def query(options)
      dynamo.query query_options(
        routing_from(options)
      )
    end

    def query_options(opts_hash)
      {
        :attributes_to_get => [ 'location' ],
        :key_conditions => {
          'opts_hash' => {
            :attribute_value_list => [ opts_hash ],
            :comparison_operator => 'EQ'
          }
        },
        :limit => 1,
        :table_name => dynamo_table_name
      }
    end

    def parameterize(options)
      Rack::Utils.build_query remove_routing(options)
    end

    def remove_routing(hash)
      hash.reject { |k| k == :routing }
    end

    def routing_from(options)
      Crimp.signature(
        options[:routing] || {}
      )
    end

    class NotFound < Exception; end
  end
end
