require 'aws-sdk'

module Alephant
  class Sequencer
    attr_reader :id, :table

    def initialize(id)
      @id = id

      dynamo_db = AWS::DynamoDB.new
      schema = {
        :hash_key => {
          :key => :string,
          :value => :string
        }
      }

      @table = dynamo_db.tables[id]
      begin
        sleep_until_table_active
      rescue AWS::DynamoDB::Errors::ResourceNotFoundException
        puts "CREATING TABLE: #{id}"
        @table = dynamo_db.tables.create(id, 10, 5, schema)

        sleep_until_table_active
      end

    end

    def sequential?(n)
      last_seen < n
    end

    def last_seen
      begin
        @table.batch_get(
          ['value'],
          ['last_seen'],
          {
            :consistent_read => true
          }
        ).first["value"].to_i
      rescue
        0
      end
    end

    def last_seen=(last_seen)
      batch = AWS::DynamoDB::BatchWrite.new
      batch.put(@id, [:key => "last_seen",:value => last_seen])
      batch.process!
    end

    private
    def sleep_until_table_active
      sleep 1 until @table.status == :active
    end

  end
end
