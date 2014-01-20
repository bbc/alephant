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

  describe "sequential?(data)" do
    before(:each) do
      Alephant::Sequencer
        .any_instance.stub(:initialize)
        .and_return(double())
    end

    context "block_given? == true" do
      it "yields to block" do
        Alephant::Sequencer
          .any_instance
          .stub(:get_last_seen)
          .and_return(1)

        instance = subject.new

        in_sequence = instance.sequential?(:data) do |last_seen, data|
          :foo
        end

        expect(in_sequence).to eq(:foo)
      end
    end

    context "block_given? == false" do
      context "get_last_seen < data['sequence_id']" do
        it "returns true" do
          Alephant::Sequencer
            .any_instance
            .stub(:get_last_seen)
            .and_return(0)

          instance = subject.new

          data = { "sequence_id" => "1" }

          expect(instance.sequential? data).to be(true)
        end
      end

      context "get_last_seen >= data['sequence_id']" do
        it "returns false" do
          Alephant::Sequencer
            .any_instance
            .stub(:get_last_seen)
            .and_return(1)

          instance = subject.new

          data = { "sequence_id" => "0" }

          expect(instance.sequential? data).to be(false)
        end
      end
    end

  end
end

