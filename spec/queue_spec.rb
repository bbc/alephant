require 'spec_helper'

describe Alephant::Queue do
  subject { Alephant::Queue }

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
