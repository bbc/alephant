require 'alephant/publisher/request'
require 'alephant/publisher/request/data_mapper_factory'
require 'alephant/publisher/request/processor'
require 'faraday'

module Renderer
  def self.create
    Alephant::Publisher::Request.create(processor, data_mapper_factory)
  end

  private

  ENDPOINT = 'http://date.jsontest.com'

  def self.base_path
    File.absolute_path(
      File.join(
        File.dirname(__FILE__),
        '..',
        'components'
      )
    )
  end

  def self.connection
    Faraday.new(url: ENDPOINT)
  end

  def self.data_mapper_factory
    Alephant::Publisher::Request::DataMapperFactory.new(connection, base_path)
  end

   def self.processor
    Alephant::Publisher::Request::Processor.new base_path
  end
end
