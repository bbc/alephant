require 'aws-sdk'

module Alephant
  class Cache

    def initialize(id)
      @s3_bucket = AWS::S3.new.buckets[id]
    end

    def get(object_id)
      @s3_bucket.objects[object_id].read
    end

    def put(object_id, data)
      @s3_bucket.objects[object_id].write(data)
    end

  end
end

