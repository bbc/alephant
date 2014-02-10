require 'aws-sdk'
require 'thread'
require 'timeout'

module Alephant
  class SequenceTable
    attr_reader :table_name

    TIMEOUT = 120
    DEFAULT_CONFIG = {
      :write_units => 5,
      :read_units => 10,
    }
    SCHEMA = {
      :hash_key => {
        :key => :string,
        :value => :string
      }
    }

    def initialize(table_name, config = DEFAULT_CONFIG)
      @mutex = Mutex.new
      @dynamo_db = AWS::DynamoDB.new
      @table_name = table_name
      @config = config
    end

    def create
      @mutex.synchronize do
        ensure_table_exists
        ensure_table_active
      end
    end

    def table
      @table ||= @dynamo_db.tables[@table_name]
    end

    def sequence_for(ident)
      rows = batch_get_value_for(ident)
      rows.length >= 1 ? rows.first['value'].to_i : 0
    end

    def set_sequence_for(ident,value)
      @mutex.synchronize do
        AWS::DynamoDB::BatchWrite.new.put(
          table_name,
          [:key => ident,:value => value]
        ).process!
      end
    end

    private
    def batch_get_value_for(ident)
      table.batch_get(['value'],[ident],batch_get_opts)
    end

    def batch_get_opts
      { :consistent_read => true }
    end

    def ensure_table_exists
      create_dynamodb_table unless table.exists?
    end

    def ensure_table_active
      sleep_until_table_active unless table_active?
    end

    def create_dynamodb_table
      @table = @dynamo_db.tables.create(
        @table_name,
        @config[:read_units],
        @config[:write_units],
        SCHEMA
      )
    end

    def table_active?
      table.status == :active
    end

    def sleep_until_table_active
      begin
        Timeout::timeout(TIMEOUT) do
          sleep 1 until table_active?
        end
      end
    end
  end
end
