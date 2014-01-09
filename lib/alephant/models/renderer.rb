require 'aws-sdk'
require 'mustache'

module Alephant
  class Renderer
    attr_reader :id

    def initialize(id)
      @id = id
    end

    def render(data)
      Mustache.render(template(@id), data)
    end

    def template(id)
      <<-eos
      {{#results}}
        <ul>
          <li>Con: {{con}}</li>
          <li>Lab: {{lab}}</li>
          <li>Lib: {{lib}}</li>
        </ul>
        {{/results}}
        <p>Sequence number: {{seq}}</p>
      eos
    end
  end
end
