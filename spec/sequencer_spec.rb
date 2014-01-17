require 'spec_helper'

describe Alephant::Sequencer do
  subject { Alephant::Sequencer }

  describe "initialize(opts, id)" do
    it "sets @id, @table_name and @table_conf" do
      sleep_until_table_active = double()

      Alephant::Sequencer.any_instance.stub(:sleep_until_table_active).and_return(sleep_until_table_active);

      AWS::DynamoDB.any_instance.stub(:initialize).and_return({
        :tables => :table_name
      })

      instance = subject.new({
        :table_name => :table_name,
        :table_conf => :table_conf
      }, :sqs_queue_id)

      expect(instance.id).to eq(:sqs_queue_id)
      expect(instance.table_name).to eq(:table_name)
      expect(instance.table_conf).to eq(:table_conf)
    end

  describe "sequential?(data)" do
    before(:each) do
      Alephant::Sequencer
        .any_instance.stub(:initialize)
        .and_return(double())
    end

    context "block provided" do
      it "yields to block" do
        Alephant::Sequencer
          .any_instance
          .stub(:get_last_seen)
          .and_return(1)

        instance = subject.new

        test = instance.sequential?(:data) do |last_seen, data|
          :foo
        end

        expect(test).to eq(:foo)
      end
    end
  end
end

