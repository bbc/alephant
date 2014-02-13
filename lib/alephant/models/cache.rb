require 'aws-sdk'
require 'alephant/logger'

module Alephant
  class Cache
    include Logger
    attr_reader :id, :bucket, :path

    def initialize(id, path)
      @id = id
      @path = path

      s3 = AWS::S3.new
      @bucket = s3.buckets[id]
      logger.info("Cache.initialize: end with id #{id} and path #{path}")
    end

    def put(id, data)
      @bucket.objects["#{@path}/#{id}"].write(data)
      logger.info("Cache.put: #{@path}/#{id}")
    end

    def get(id)
      logger.info("Cache.get: #{@path}/#{id}")
      @bucket.objects["#{@path}/#{id}"].read
    end
  end
end

