require 'rack'
require 'env'
require 'models/cacher'

class ViewCache
  def call(env)
    cache_id = "s3-render-example"
    cache = Cacher.new(cache_id)

    content = cache.get("example")

    [200, {"Content-Type" => "text/html"}, [content]]
  end
end

