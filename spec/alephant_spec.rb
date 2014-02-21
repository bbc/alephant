require 'spec_helper'

describe Alephant::Alephant do

  before(:each) do
    Alephant::Writer.any_instance.stub(:initialize)
    Alephant::Queue.any_instance.stub(:initialize)
    Alephant::Support::Parser.any_instance.stub(:initialize)
    Alephant::Sequencer::Sequencer.any_instance.stub(:initialize)
  end

  describe "#initialize(opts = {}, logger)" do
    it "sets parser, sequencer, queue and writer" do
      expect(subject.writer).to be_a Alephant::Writer
      expect(subject.queue).to be_a Alephant::Queue
      expect(subject.parser).to be_a Alephant::Support::Parser
      expect(subject.sequencer).to be_a Alephant::Sequencer::Sequencer
    end
  end

  describe "#run!" do
    it "returns a Thread" do
      expect(subject.run!).to be_a(Thread)
    end

    it "calls @queue.poll" do
      subject.should_receive(:receive).with(:msg)

      expect_any_instance_of(Alephant::Queue)
      .to receive(:poll)
      .and_yield(:msg)

      t = subject.run!
      t.join
    end
  end

  describe "#receive(msg)" do
    subject { Alephant::Alephant.new }

    before(:each) do
      Alephant::Support::Parser.any_instance
        .stub(:parse)
        .and_return(:parsed_msg)
      Alephant::Sequencer::Sequencer
        .any_instance.stub(:sequence_id_from)
        .and_return(:sequence_id)
      Alephant::Sequencer::Sequencer
        .any_instance.stub(:set_last_seen)
    end

    context "message is nonsequential" do
      before(:each) do
        Alephant::Sequencer::Sequencer
          .any_instance.stub(:sequential?)
          .and_return(false)
      end

      it "should not call write" do
        Alephant::Writer.any_instance
          .should_not_receive(:write)

        subject.receive(:msg)
      end
    end

    context "message is sequential" do
      before(:each) do
        Alephant::Sequencer::Sequencer
          .any_instance.stub(:sequential?)
          .and_return(true)
      end

      it "calls writer with a parsed message and sequence_id" do
        Alephant::Writer.any_instance
          .should_receive(:write).with(:parsed_msg, :sequence_id)

        subject.receive(:msg)
      end
    end
  end

end
