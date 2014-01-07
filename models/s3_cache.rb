require 'aws-sdk'

class S3Cache

  def initialize(id)
    @s3_bucket = AWS::S3.new.buckets[id]
  end

  def get(object_id)
    puts "LOG: Cache read for #{object_id} at #{Time.now.to_i}"
    @s3_bucket.objects[object_id].read
  end

  def last_updated(object_id)
    puts "LOG: Getting last updated for #{object_id} at #{Time.now.to_i}"
    @s3_bucket.objects[object_id].metadata['last_updated']
  end

  def put(object_id, data)
    puts "LOG: Cache write for #{object_id} at #{Time.now.to_i}"
    @s3_bucket.objects[object_id].write(data)
    @s3_bucket.objects[object_id].metadata['last_updated'] = Time.now.to_i
  end

end


