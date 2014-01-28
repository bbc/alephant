require 'sinatra/base'
require 'alephant/models/renderer'
require 'alephant/views/preview'
require 'json'

module Alephant
  class Preview < Sinatra::Base

    get '/preview/:id/:region/?:fixture?' do
      render_preview
    end

    get '/component/:id/?:fixture?' do
      render_component
    end

    def render_preview
      p = Views::Preview.new
      p.regions[region] = render_component
      p.template_file = preview_template_location

      p.render
    end

    def render_component
      Renderer.new(id, base_path).render(fixture_data)
    end

    private
    def region
      params['region']
    end

    def id
      params['id']
    end

    def fixture
      params['fixture'] || params['id']
    end

    def fixture_data
      JSON.parse(File.open(fixture_location).read)
    end

    def base_path
      "#{Dir.pwd}/views"
    end

    def fixture_location
      "#{base_path}/fixtures/#{fixture}.json"
    end

    def preview_template_location
      "#{base_path}/templates/preview.mustache"
    end
  end
end
