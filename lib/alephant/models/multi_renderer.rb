module Alephant
  class MultiRenderer
    DEFAULT_LOCATION = 'views'
    DEFAULT_MODEL = 'example'

    def initialize(view_base_path=nil)
      self.base_path = view_base_path unless view_base_path.nil?

      @logger = ::Alephant.logger
    end

    def base_path
      @base_path || DEFAULT_LOCATION
    end

    def base_path=(path)
      if File.directory?(path)
        @base_path = path
      else
        raise Errors::InvalidViewPath
      end
    end

    def render(data)
      model_object = model(data)

      Dir.glob("#{base_path}/templates/*").reduce(Hash.new(0)) do |obj, file|
        id = file.split('/').last.sub(/\.mustache/, '')

        obj.tap { |o| o[id.to_sym] = ::Alephant::Renderer.new(id, base_path, model_object).render.chomp! }
      end
    end

    def model(data)
      model_location = File.join(base_path, 'models', "#{DEFAULT_MODEL}.rb")

      begin
        require model_location
        klass = ::Alephant::Views.get_registered_class(DEFAULT_MODEL)
        @logger.info("Renderer.model: klass set to #{klass}")
      rescue Exception => e
        @logger.error("Renderer.model: view model with id #{id} not found")
        raise Errors::ViewModelNotFound
      end

      @logger.info("Renderer.model: creating new klass with data #{data}")

      klass.new(data)
    end
  end
end
