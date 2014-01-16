require 'spec_helper'

describe Alephant::Queue do
  subject { Alephant::Queue }

  describe "initialize(id)" do
    it "sets @q to an instance of AWS:SQS::Queue" do
      AWS::SQS::Queue.any_instance.stub(:exists?)
        .and_return(true)

      instance = subject.new(:id)
      expect(instance.q).to be_a(AWS::SQS::Queue)
    end

    context "@q.exists? == false" do
      it "@q = AWS::SQS.new.queues.create(id), then sleep_until_queue_exists" do
        queue = double()
        queue.stub(:exists?).and_return(false)

        queue_collection = double()
        queue_collection.should_receive(:create).with(:id)
          .and_return(queue)

        sqs = double()
        sqs.should_receive(:queues)
          .and_return({ :id => queue }, queue_collection)

        AWS::SQS.should_receive(:new).and_return(sqs)

        subject.any_instance.should_receive(:sleep_until_queue_exists)

        instance = subject.new(:id)
      end
    end
  end

  describe "poll(*args, &block)" do
    it "calls @q.poll(*args, &block)" do
      block = double()
      block.should_receive(:called)

      AWS::SQS::Queue.any_instance.stub(:exists?)
        .and_return(true)

      AWS::SQS::Queue.any_instance.should_receive(:poll).with(:arg).and_yield

      subject.new(:id).poll(:arg) do
        block.called
      end
    end
  end

  describe "sleep_until_queue_exists" do
    context "@q.exists? == true" do
      it "should not call sleep" do
        AWS::SQS::Queue.any_instance.stub(:exists?)
          .and_return(true)

        Alephant::Queue.any_instance.stub(:sleep)
        Alephant::Queue.any_instance.should_not_receive(:sleep)

        subject.new(:id).sleep_until_queue_exists
      end
    end
    context "@q.exists? == false" do
      it "should call sleep(1)" do
        AWS::SQS::Queue.any_instance.stub(:exists?)
          .and_return(true, false, true)

        Alephant::Queue.any_instance.stub(:sleep)
        Alephant::Queue.any_instance.should_receive(:sleep).with(1)

        subject.new(:id).sleep_until_queue_exists
      end
    end
  end

end
