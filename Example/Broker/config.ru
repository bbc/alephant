$: << "."

require "env"
require "alephant/broker"
require "alephant/broker/load_strategy/s3"

config = {
    :sequencer_table_name      => "development_sequencer",
    :lookup_table_name         => "development_lookup",
    :bucket_base_path          => "election-data-shared",
    :s3_object_path            => "election-data-shared/development/html",
    :s3_bucket_id              => "election-data-shared",
    :elasticache_cache_version => "1"
}

run Alephant::Broker::Application.new(
  Alephant::Broker::LoadStrategy::S3.new, config
)
