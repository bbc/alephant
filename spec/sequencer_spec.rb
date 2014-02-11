require 'spec_helper'

describe Alephant::Sequencer::Sequencer do
  let(:data)     { double() }
  let(:last_seen) { 42 }
  let(:ident) { :ident }
  let(:jsonpath) { :jsonpath }
  let(:sequence_table) { double().tap { |o| o.stub(:create) } }
  subject { Alephant::Sequencer::Sequencer.new(sequence_table, ident, jsonpath) }

  describe "#initialize(opts, id)" do
    it "sets @jsonpath, @ident" do
      expect(subject.jsonpath).to eq(jsonpath)
      expect(subject.ident).to eq(ident)
    end

    it "calls create on sequence_table" do
      table = double()
      table.should_receive(:create)

      Alephant::Sequencer::Sequencer.new(table, ident, jsonpath)
    end
  end

  describe "#get_last_seen" do
    it "returns sequence_table.sequence_for(ident)" do
      table = double()
      table.stub(:create)
      table.should_receive(:sequence_for).with(ident).and_return(:expected_value)

      expect(
        Alephant::Sequencer::Sequencer.new(table, ident).get_last_seen
      ).to eq(:expected_value)
    end
  end

  describe "#set_last_seen(data)" do
    before(:each) do
      Alephant::Sequencer::Sequencer.any_instance.stub(:sequence_id_from).and_return(last_seen)
    end

    it "calls set_sequence_for(ident, last_seen)" do
      table = double()
      table.stub(:create)
      table.should_receive(:set_sequence_for).with(ident, last_seen)

      Alephant::Sequencer::Sequencer.new(table, ident).set_last_seen(data)
    end
  end

  describe "#sequential?(data, jsonpath)" do

    before(:each) do
      Alephant::Sequencer::Sequencer.any_instance.stub(:get_last_seen).and_return(1)
      data.stub(:body).and_return('sequence_id' => id_value)
    end

    context "jsonpath = '$.sequence_id'" do
      let(:jsonpath) { '$.sequence_id' }
      subject { Alephant::Sequencer::Sequencer.new(sequence_table, :ident, jsonpath) }
      context "sequential" do
        let(:id_value) { 2 }
        it "is true" do
          expect(subject.sequential?(data)).to be_true
        end
      end

      context "nonsequential" do
        let(:id_value) { 0 }
        it "is false" do
          expect(subject.sequential?(data)).to be_false
        end
      end
    end

    context "jsonpath = nil" do
      let(:jsonpath) { nil }
      subject { Alephant::Sequencer::Sequencer.new(sequence_table, :ident, jsonpath) }

      context "sequential" do
        let(:id_value) { 2 }
        it "is true" do
          expect(subject.sequential?(data)).to be_true
        end
      end

      context "nonsequential" do
        let(:id_value) { 0 }
        it "is false" do
          expect(subject.sequential?(data)).to be_false
        end
      end
    end

  end
end

