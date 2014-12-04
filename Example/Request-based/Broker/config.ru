$: << '.'

require 'env'
require 'alephant/broker'
require 'alephant/broker/load_strategy/http'

url_config = {

}

url_locator = UrlLocator.new url_config

config = {

}

run Alephant::Broker::Application.new(
  Alephant::Broker::LoadStrategy::HTTP.new, config
)
