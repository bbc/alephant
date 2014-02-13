require 'json'

module Alephant
  class Parser
    def parse data
      JSON.parse(data, :symbolize_names => true)
    end
  end
end

