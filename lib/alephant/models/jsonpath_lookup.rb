require 'jsonpath'
require 'json'

module Alephant
  class JsonPathLookup
    attr_reader :path
    def initialize(path)
      @path = path
      @jsonpath = JsonPath.new(path)
    end

    def lookup(msg)
      @jsonpath.on(JSON.parse(msg)).first
    end
  end
end
