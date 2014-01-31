require 'aws-sdk'
require 'mustache'

module Alephant
  class Renderer
    DEFAULT_LOCATION = 'views'

    attr_reader :id

    def initialize(id, view_base_path = nil, model)
      @logger = ::Alephant.logger

      @id = id
      self.base_path = view_base_path unless view_base_path.nil?

      @model = model

      @logger.info("Renderer.initialize: end with self.base_path set to #{self.base_path}")
    end

    def render(data)
      @logger.info("Renderer.render: rendered template with id #{id}")

      Mustache.render(
        template,
        @model
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

    def template
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
