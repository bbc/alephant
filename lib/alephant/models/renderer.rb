require 'aws-sdk'
require 'mustache'

module Alephant
  class Renderer
    DEFAULT_LOCATION = 'views'

    attr_reader :id

    def initialize(id)
      @id = id
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
        File.join('views','models',"#{id}.rb")
      require model_location

      eval(id.camelize).new(data)
    end

    def template(id)
      template_location =
        File.join('views','templates',"#{id}.mustache")

      File.open(template_location).read
    end
  end
end
