require 'aws-sdk'

module Alephant
  class Cache
    attr_reader :id, :bucket, :path

    def initialize(id, path)
      @id = id
      @path = path

      s3 = AWS::S3.new
      @bucket = s3.buckets[id]
    end

    def put(id, data)
      @bucket.objects["#{@path}/#{id}"].write(data)
    end

    def get(id)
      @bucket.objects["#{@path}/#{id}"].read
    end
  end
end

