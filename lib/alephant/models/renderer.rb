require 'aws-sdk'
require 'mustache'

module Alephant
  class Renderer
    attr_reader :id

    def initialize(id, base_path, model)
      @logger    = ::Alephant.logger
      @id        = id
      @base_path = base_path
      @model     = model
      @logger.info("Renderer.initialize: end with @base_path set to #{@base_path}")
    end

    def render
      @logger.info("Renderer.render: rendered template with id #{id}")

      Mustache.render(template, @model)
    end

    def template
      template_location = File.join(@base_path, 'templates', "#{id}.mustache")

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
