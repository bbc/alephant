require 'alephant/logger'

module Alephant
  class RenderMapper
    include ::Alephant::Logger
    DEFAULT_LOCATION = 'components'

    def initialize(component_id, view_base_path=nil)
      self.base_path = "#{view_base_path}/#{component_id}" unless view_base_path.nil?
      @component_id = component_id
    end

    def base_path
      @base_path || DEFAULT_LOCATION
    end

    def base_path=(path)
      @base_path = File.directory?(path) ? path : (raise Errors::InvalidViewPath)
    end

    def generate(data)
      template_locations.reduce({}) do |obj, file|
        template_id = template_id_for file

        obj.tap { |o| create_renderer(template_id, base_path, data) }
      end
    end

    def create_renderer(template_file, base_path, data)
      model = instantiate_model(template_file, data)
      Renderer.create(template_file, base_path, model)
    end

    private
    def instantiate_model(template_file, data)
      require model_location_for template_file
      Views.get_registered_class("#{@component_id}_#{template_file}").new(data)
    end

    private
    def create_model(template_file, data)
    end

    def model_location_for(template_file)
      File.join(base_path, 'models', "#{template_file}.rb")
    end

   def template_locations
      Dir[template_base_path]
    end

    def template_base_path
      "#{base_path}/templates/*"
    end

    def template_id_for(template_location)
      template_location.split('/').last.sub(/\.mustache/, '')
    end

  end
end
