require 'logger'

module Alephant
  def self.logger
    ::Alephant::LogSystem.logger
  end

  def self.logger=(value)
    ::Alephant::LogSystem.logger = value
  end

  class LogSystem
    def self.logger
      @logger ||= Logger.new(STDOUT)
    end

    def self.logger=(value)
      @logger = value
    end
  end
end

