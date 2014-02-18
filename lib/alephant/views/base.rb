require 'mustache'

module Alephant::Views
  class Base < Mustache
    attr_accessor :data

    def initialize(data = {})
      @data = data
    end

    def self.inherited(subclass)
      ::Alephant::Views.register(subclass)
    end
  end
end

