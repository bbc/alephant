require "crimp"

class App
  def self.call(env)
    response = bucket.objects[get_key_for(component env)].read
    [200, {"Content-Type" => "text/html"}, [response]]
  rescue => exception
    [500, {"Content-Type" => "text/plain"}, ["#{exception.backtrace}"]]
  end

  private

  def self.component(env)
    env["REQUEST_PATH"].split("/").last
  end

  def self.s3
    @@s3 ||= AWS::S3.new
  end

  def self.bucket
    @@bucket ||= s3.buckets[ENV["S3_BUCKET"]]
  end

  def self.get_key_for(component)
    Crimp.signature component
  end
end
