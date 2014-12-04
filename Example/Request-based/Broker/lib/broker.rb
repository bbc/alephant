require 'alephant/broker'
require 'alephant/broker/load_strategy/http'
require_relative 'dynamic_url_locator'

module Broker
  def self.create
    Alephant::Broker::Application.new load_strategy
  end

  private

  def self.config
    {
      :dynamo_table_name         => ENV['DYNAMO_TABLE_NAME'],
      :elasticache_cache_version => ENV['ELASTICACHE_CACHE_VERSION']
    }
  end

  def self.dynamic_url_locator
    DynamicUrlLocator.new config
  end

  def self.load_strategy
    Alephant::Broker::LoadStrategy::HTTP.new dynamic_url_locator
  end
end
