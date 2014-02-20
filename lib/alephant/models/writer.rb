require 'alephant/models/jsonpath_lookup'
require 'crimp'

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
        store(id, r.render, data[:options], version)
      end
    end

    private
    def store(id, content, options, version)
      location = location_for(
        id,
        Crimp.signature(options),
        version
      )

      cache.put(location, content)
      lookup(id).write(options, location)
    end

    def lookup(component_id)
      Lookup.create(@lookup_table_name, component_id)
    end

    def location_for(component_id, options_hash, version = nil)
      base_name = "#{@renderer_id}/#{component_id}/#{options_hash}"
      version ? "#{base_name}/#{version}" : base_name
    end

  end
end
