require 'alephant/renderer/views/html'

class TestComponent < Alephant::Renderer::Views::Html
  def date
    @data.date
  end

  def time
    @data.time
  end
end
