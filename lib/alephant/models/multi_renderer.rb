module Alephant
  class MultiRenderer
    DEFAULT_LOCATION = 'components'

    def initialize(component_id, view_base_path=nil)
      self.base_path = "#{view_base_path}/#{component_id}" unless view_base_path.nil?
      @component_id = component_id
      @logger = ::Alephant.logger
    end

    def base_path
      @base_path || DEFAULT_LOCATION
    end

    def base_path=(path)
      @base_path = File.directory?(path) ? path : (raise Errors::InvalidViewPath)
    end

    def render(data)
      template_locations.reduce({}) do |obj, file|
        template_id = template_id_for file

        obj.tap do |o|
          o[template_id.to_sym] = render_template(
            template_id,
            data
          )
        end
      end
    end

    def render_template(template_file, data)
      renderer(
        template_file,
        base_path,
        data
      ).render
    end

    def renderer(template_file, base_path, data)
      Renderer.new(template_file, base_path, create_instance(template_file, data))
    end

    def create_instance(template_file, data)
      begin
        create_model(template_file, data)
      rescue Exception => e
        @logger.error("Renderer.model: exeception #{e.message}")
        raise Errors::ViewModelNotFound
      end
    end

    private
    def create_model(template_file, data)
      require model_location_for template_file
      klass = Views.get_registered_class("#{@component_id}_#{template_file}")

      @logger.info("Renderer.model: creating new klass #{klass}")
      klass.new(data)
    end

    def model_location_for(template_file)
      File.join(base_path, 'models', "#{template_file}.rb")
    end

    def template_locations
      Dir.glob("#{base_path}/templates/*")
    end

    def template_id_for(template_location)
      template_location.split('/').last.sub(/\.mustache/, '')
    end

  end
end
