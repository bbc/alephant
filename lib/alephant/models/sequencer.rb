require 'jsonpath'

module Alephant

  class Sequencer
    attr_reader :ident, :jsonpath

    def initialize(sequence_table, id, sequence_path = nil)
      @mutex = Mutex.new
      @sequence_table = sequence_table
      @jsonpath = sequence_path
      @ident = id

      ::Alephant.logger.info("Sequencer.initialize: with id #{@ident}")
      @sequence_table.create
    end

    def sequential?(data)
      get_last_seen < sequence_id_from(data)
    end

    def set_last_seen(data)
      last_seen_id = sequence_id_from(data)

      @sequence_table.set_sequence_for(ident, last_seen_id)
      ::Alephant.logger.info("Sequencer.set_last_seen: #{ident}:#{last_seen_id}")
    end

    def sequence_id_from(data)
      jsonpath.nil? ?
        default_sequence_id_for(data) :
        sequence_from_jsonpath_for(data)
    end

    def get_last_seen
      @sequence_table.sequence_for(ident)
    end

    private
    def sequence_from_jsonpath_for(data)
      JsonPath.on(data.body, jsonpath).first
    end

    def default_sequence_id_for(data)
      data.body['sequence_id'].to_i
    end

  end
end
