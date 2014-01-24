require 'aws-sdk'

module Alephant
  class Cache
    attr_reader :id, :bucket, :path

    def initialize(id, path)
      @logger = ::Alephant.logger
      @id = id
      @path = path

      s3 = AWS::S3.new
      @bucket = s3.buckets[id]
      @logger.info("Cache.initialize: end with id #{id} and path #{path}")
    end

    def put(id, data)
      @bucket.objects["#{@path}/#{id}"].write(data)
      @logger.info("Cache.put: #{@path}/#{id} and write data #{data}")
    end

    def get(id)
      @logger.info("Cache.get: #{@path}/#{id}")
      @bucket.objects["#{@path}/#{id}"].read
    end
  end
end

