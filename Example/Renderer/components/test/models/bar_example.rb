require "alephant/renderer/views/html"

class BarExample < Alephant::Renderer::Views::Html
  def foo
    @data[:title]
  end

  def bar
    @data[:timestamp]
  end
end
