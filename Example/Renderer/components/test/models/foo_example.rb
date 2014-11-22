require "alephant/renderer/views/html"

class FooExample < Alephant::Renderer::Views::Html
  def foo
    @data[:title].upcase
  end

  def bar
    @data[:timestamp]
  end
end
