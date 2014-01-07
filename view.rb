require 'rack'

require 'config'
require 'models/s3_cache'

class ViewCache
  def call(env)
    cache_id = "s3-render-example"
    cache = S3Cache.new(cache_id)

    content = cache.get("example")

    [200, {"Content-Type" => "text/html"}, [content]]
  end
end
