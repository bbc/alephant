require "alephant/broker"
require "alephant/broker/load_strategy/s3"

config = {
  :bucket_id => ENV["S3_BUCKET"]
  # :path              => "foo",
  # :lookup_table_name => "test_lookup"
}

request = {
  'PATH_INFO'      => "/component/foo",
  'REQUEST_METHOD' => "GET"
}

Alephant::Broker::Application.new(
  Alephant::Broker::LoadStrategy::S3.new,
  config
).call(request).tap do |response|
  puts "status:  #{response.status}"
  puts "content: #{response.content}"
end

# require "crimp"

# class App
#   def self.call(env)
#     response = bucket.objects[get_key_for(component env)].read
#     [200, {"Content-Type" => "text/html"}, [response]]
#   rescue => exception
#     [500, {"Content-Type" => "text/plain"}, ["#{exception.backtrace}"]]
#   end

#   private

#   def self.component(env)
#     env["REQUEST_PATH"].split("/").last
#   end

#   def self.s3
#     @@s3 ||= AWS::S3.new
#   end

#   def self.bucket
#     @@bucket ||= s3.buckets[ENV["S3_BUCKET"]]
#   end

#   def self.get_key_for(component)
#     Crimp.signature component
#   end
# end
