require 'spec_helper'

describe Alephant::Sequencer do
  subject { Alephant::Sequencer }

  describe "initialize(opts, id)" do

    it "sets @id, @table_name and @table_conf" do
      AWS::DynamoDB.any_instance.stub(:initialize).and_return({
        :tables => {
          :status => :active
        }
      })

      Alephant::Sequencer.any_instance.stub(:sleep_until_table_active)

      instance = subject.new({
        :table_name => :table_name,
        :table_conf => :table_conf
      }, :sqs_queue_id)

      expect(instance.id).to eq(:sqs_queue_id)
      expect(instance.table_name).to eq(:table_name)
      expect(instance.table_conf).to eq(:table_conf)
    end

    context "sleep_until_table_active raises" do
      context "AWS::DynamoDB::Errors::ResourceNotFoundException" do
        it "dynamo_db.tables.create(@table_name, opts) then sleep_until_table_active" do
          opts = {
              :table_name => :table_name,
              :table_conf => {
                :read_units => :read_units,
                :write_units => :write_units,
                :schema => :schema
              }
          }

          table_collection = double()
          table_collection.should_receive(:create).with(
            opts[:table_name],
            opts[:table_conf][:read_units],
            opts[:table_conf][:write_units],
            opts[:table_conf][:schema]
          )

          AWS::DynamoDB.any_instance.stub(:tables).and_return({},table_collection)

          Alephant::Sequencer
            .any_instance
            .stub(:sleep_until_table_active).and_yield do
              @times_called ||= 0
              raise AWS::DynamoDB::Errors::ResourceNotFoundException if @times_called == 0
              @times_called += 1
            end

          subject.new(opts, :id)
        end
      end
    end
  end

  describe "sequential?(data, jsonpath = nil)" do
    let(:jsonpath) { '$.sequence_id' }
    let(:instance) { subject.new }
    let(:id_value) { 0 }
    let(:data)     {{ 'sequence_id' => id_value }}

    before(:each) do
      Alephant::Sequencer
        .any_instance.stub(:initialize)
        .and_return(double())

      Alephant::Sequencer
        .any_instance
        .stub(:get_last_seen)
        .and_return(1)
    end

    context "jsonpath provided" do
      context "in sequence" do
        let(:id_value) { 2 }

        it "looks up data using jsonpath (returns true)" do
          in_sequence = instance.sequential?(data, jsonpath)
          expect(in_sequence).to eq(true)
        end
      end

      context "out of sequence" do
        let(:id_value) { 0 }

        it "looks up data using jsonpath (returns false)" do
          in_sequence = instance.sequential?(data, jsonpath)
          expect(in_sequence).to eq(false)
        end
      end
    end

    context "jsonpath NOT provided" do
      context "in sequence" do
        let(:id_value) { 2 }

        it "looks up data using a fallback key (returns true)" do
          in_sequence = instance.sequential?(data)
          expect(in_sequence).to eq(true)
        end
      end

      context "out of sequence" do
        let(:id_value) { 0 }

        it "looks up data using a fallback key (returns false)" do
          in_sequence = instance.sequential?(data)
          expect(in_sequence).to eq(false)
        end
      end
    end

  end
end

