module MyApp
  class Bar < ::Alephant::Views::Base
    def content
      @data[:content]
    end
  end
end
