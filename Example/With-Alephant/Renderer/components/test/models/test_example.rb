require "alephant/renderer/views/html"

class TestExample < Alephant::Renderer::Views::Html
  def foo
    @data[:title]
  end

  def bar
    @data[:timestamp]
  end
end
