$: << "."

require "env"
require "alephant/broker"
require "alephant/broker/load_strategy/s3"

config = {
  :bucket_id            => ENV["S3_BUCKET"],
  :lookup_table_name    => ENV["DYNAMO_LU"],
  :sequencer_table_name => ENV["DYNAMO_SQ"]
}

run Alephant::Broker::Application.new(
  Alephant::Broker::LoadStrategy::S3.new, config
)
