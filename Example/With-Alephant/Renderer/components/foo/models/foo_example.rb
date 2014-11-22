require "alephant/renderer/views/html"

class FooExample < Alephant::Renderer::Views::Html
  def foo
    @data[:title]
  end

  def bar
    @data[:timestamp]
  end
end
