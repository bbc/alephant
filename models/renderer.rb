require 'aws-sdk'
require 'mustache'

class Renderer
  def render(id, data)
    Mustache.render(template(id), data)
  end

  private
  def template(id)
    <<-eos
      <ul>
        <li>Con: {{con}}</li>
        <li>Lab: {{lab}}</li>
        <li>Lib: {{lib}}</li>
      </ul>
    eos
  end

end
