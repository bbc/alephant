require 'alephant/models/jsonpath_lookup'

module Alephant
  class Writer
    attr_reader :mapper, :cache

    def initialize(opts)
      @renderer_id =
        opts[:renderer_id]
      @cache = Cache.new(
        opts[:s3_bucket_id],
        opts[:s3_object_path]
      )
      @mapper = RenderMapper.new(
        opts[:renderer_id],
        opts[:view_path]
      )
      @lookup_table_name =
        opts[:lookup_table_name]
    end

    def write(data, version = nil)
      mapper.generate(data).each do |id, r|
        store(id, r.render, location_for(id, version), data[:options])
      end
    end

    private
    def store(id, content, location, options)
      cache.put(location, content)
      lookup(id).write(options, location)
    end

    def lookup(component_id)
      Lookup.create(@lookup_table_name, component_id)
    end

    def location_for(component_id, version = nil)
      base_name = "#{@renderer_id}/#{component_id}"
      version ? "#{base_name}/#{version}" : base_name
    end

  end
end
