require 'aws-sdk'
require 'mustache'

module Alephant
  class Renderer
    DEFAULT_LOCATION = 'views'

    attr_reader :id

    def initialize(id, view_base_path=nil)
      @logger = ::Alephant.logger

      @id = id
      self.base_path = view_base_path unless view_base_path.nil?

      @logger.info("Renderer.initialize: end with self.base_path set to #{self.base_path}")
    end

    def render(data)
      @logger.info("Renderer.render: rendered template with id #{id}")
      Mustache.render(
        template(@id),
        model(@id,data)
      )
    end

    def base_path
      @base_path || DEFAULT_LOCATION
    end

    def base_path=(path)
      if File.directory?(path)
        @base_path = path
      else
        @logger.error("Renderer.base_path=(path): error of invalid view path #{path}")
        raise Errors::InvalidViewPath
      end
    end

    def model(id, data)
      model_location = File.join(base_path, 'models', "#{id}.rb")

      begin
        require model_location
        klass = ::Alephant::Views.get_registered_class(id)
        @logger.info("Renderer.model: klass set to #{klass}")
      rescue Exception => e
        @logger.error("Renderer.model: view model with id #{id} not found")
        raise Errors::ViewModelNotFound
      end

      @logger.info("Renderer.model: creating new klass with data #{data}")
      klass.new(data)
    end

    def template(id)
      template_location = File.join(base_path,'templates',"#{id}.mustache")
      begin
        @logger.info("Renderer.template: #{template_location}")
        File.open(template_location).read
      rescue Exception => e
        @logger.error("Renderer.template: view tempalte with id #{id} not found")
        raise Errors::ViewTemplateNotFound
      end
    end
  end
end
