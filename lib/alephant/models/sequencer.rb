require 'aws-sdk'

module Alephant
  class Sequencer
    attr_reader :id, :table_name, :table_conf

    def table_conf_defaults
      {
        :write_units => 5,
        :read_units => 10,
        :schema => {
          :hash_key => {
            :key => :string,
            :value => :string
          }
        }
      }
    end

    def initialize(opts, id)
      dynamo_db = AWS::DynamoDB.new

      @id = id
      @table_name = opts[:table_name]
      @table_conf = opts[:table_conf] || table_conf_defaults
      @table = dynamo_db.tables[@table_name]

      begin
        sleep_until_table_active
      rescue AWS::DynamoDB::Errors::ResourceNotFoundException
        @table = dynamo_db.tables.create(
          @table_name,
          @table_conf[:read_units],
          @table_conf[:write_units],
          @table_conf[:schema]
        )

        sleep_until_table_active
      end
    end

    def sequential?(data)
      if block_given?
        yield(get_last_seen, data)
      else
        get_last_seen < data[:sequence_id]
      end
    end

    private
    def get_last_seen
      begin
        @table.batch_get(
          ['value'],
          [@id],
          {
            :consistent_read => true
          }
        ).first["value"].to_i
      rescue
        0
      end
    end

    def set_last_seen(data)
      last_seen_id = block_given? ? yield(data) : data[:sequence_id]

      batch = AWS::DynamoDB::BatchWrite.new
      batch.put(@table_name, [:key => @id,:value => last_seen_id])
      batch.process!
    end

    def sleep_until_table_active
      sleep 1 until @table.status == :active
    end

  end
end
