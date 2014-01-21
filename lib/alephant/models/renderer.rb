require 'aws-sdk'
require 'mustache'

module Alephant
  class Renderer
    DEFAULT_LOCATION = 'views'

    attr_reader :id

    def initialize(id, view_base_path=nil)
      @id = id
      self.base_path = view_base_path unless view_base_path.nil?
    end

    def render(data)
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
        raise Errors::InvalidViewPath
      end
    end

    def model(id, data)
      model_location =
        File.join(base_path,'models',"#{id}.rb")

      begin
        require model_location
        klass = ::Alephant::Views.get_registered_class(id)
      rescue Exception => e
        raise Errors::ViewModelNotFound
      end

      klass.new(data)
    end

    def template(id)
      template_location =
        File.join(base_path,'templates',"#{id}.mustache")
      begin
        File.open(template_location).read
      rescue Exception => e
        raise Errors::ViewTemplateNotFound
      end
    end
  end
end
