require 'aws-sdk'
require 'jsonpath'

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
      @logger = ::Alephant.logger

      dynamo_db = AWS::DynamoDB.new

      @id = id
      @table_name = opts[:table_name]
      @table_conf = opts[:table_conf] || table_conf_defaults
      @table = dynamo_db.tables[@table_name]

      begin
        sleep_until_table_active
      rescue AWS::DynamoDB::Errors::ResourceNotFoundException
        @logger.error("Sequencer.initialize: DynamoDB resource was not found.")

        @table = dynamo_db.tables.create(
          @table_name,
          @table_conf[:read_units],
          @table_conf[:write_units],
          @table_conf[:schema]
        )

        @logger.info("Sequencer.initialize: Creating table with name #{@table_name}, read units #{@table_conf[:read_units]}, write units #{@table_conf[:write_units]}, schema #{@table_conf[:schema]}")

        sleep_until_table_active
      end

      @logger.info("Sequencer.initialize: end with id #{@id}")
    end

    def sequential?(data, jsonpath = nil)
      get_last_seen < operator(data, jsonpath)
    end

    def set_last_seen(data, jsonpath)
      last_seen_id = operator(data, jsonpath)

      batch = AWS::DynamoDB::BatchWrite.new
      batch.put(@table_name, [:key => @id,:value => last_seen_id])
      batch.process!
      @logger.info("Sequencer.set_last_seen: id #{id} and last_seen_id #{last_seen_id}")
    end

    def operator(data, jsonpath)
      jsonpath.nil? ?
        data['sequence_id'].to_i :
        JsonPath.on(data, jsonpath).first
    end

    def get_last_seen
      begin
        @table.batch_get(
          ['value'],
          [@id],
          {
            :consistent_read => true
          }
        ).first["value"].to_i
      rescue Exception => e
        trace = e.backtrace.join('\n')
        @logger.error("Sequencer.get_last_seen: id #{id}\nmessage: #{e.message}\ntrace: #{trace}")
        0
      end
    end

    def sleep_until_table_active
      sleep 1 until @table.status == :active
    end

  end
end
