$: << "."

require "env"
require "alephant/broker"
require "alephant/broker/load_strategy/s3"

config = {
    :elasticache_cache_version => ENV["ELASTICACHE_CACHE_VERSION"],
    :sequencer_table_name      => ENV["SEQUENCER_TABLE_NAME"],
    :lookup_table_name         => ENV["LOOKUP_TABLE_NAME"],
    :s3_bucket_id              => ENV["S3_BUCKET_ID"],
    :s3_object_path            => ENV["S3_OBJECT_PATH"]
}

run Alephant::Broker::Application.new(
  Alephant::Broker::LoadStrategy::S3.new, config
)
