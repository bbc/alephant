require 'spec_helper'

describe Alephant::Alephant do
  subject { Alephant::Alephant }

  describe "initialize(opts = {})" do
    before(:each) do
      sequencer      = double()
      queue          = double()
      cache          = double()
      multi_renderer = double()

      Alephant::Sequencer.stub(:create).and_return(sequencer)
      Alephant::Queue.any_instance.stub(:initialize).and_return(queue)
      Alephant::Cache.any_instance.stub(:initialize).and_return(cache)
      Alephant::MultiRenderer.any_instance.stub(:initialize).and_return(multi_renderer)
    end

    it "sets specified options" do
      instance = subject.new({
        :s3_bucket_id   => :s3_bucket_id,
        :s3_object_path => :s3_object_path,
        :s3_object_id   => :s3_object_id,
        :table_name     => :table_name,
        :sqs_queue_id   => :sqs_queue_id,
        :component_id   => :component_id,
        :sequence_id    => :sequence_id
      })

      expect(instance.s3_bucket_id).to eq(:s3_bucket_id);
      expect(instance.s3_object_path).to eq(:s3_object_path);
      expect(instance.s3_object_id).to eq(:s3_object_id);
      expect(instance.table_name).to eq(:table_name);
      expect(instance.sqs_queue_id).to eq(:sqs_queue_id);
      expect(instance.component_id).to eq(:component_id);
      expect(instance.sequence_id).to eq(:sequence_id);
    end

    it "sets unspecified options to nil" do
      instance = subject.new

      expect(instance.s3_bucket_id).to eq(nil);
      expect(instance.s3_object_path).to eq(nil);
      expect(instance.s3_object_id).to eq(nil);
      expect(instance.table_name).to eq(nil);
      expect(instance.sqs_queue_id).to eq(nil);
      expect(instance.component_id).to eq(nil);
      expect(instance.sequence_id).to eq(nil);
    end

    context "initializes @sequencer" do
      it "with Sequencer.create(:table_name, @sqs_queue_id)" do
        Alephant::Sequencer
          .should_receive(:create)
          .with(:table_name, :sqs_queue_id, :sequence_id)

        instance = subject.new({
          :table_name   => :table_name,
          :sqs_queue_id => :sqs_queue_id,
          :sequence_id => :sequence_id
        })
      end
    end

    context "initializes @queue" do
      it "with Queue.new(@sqs_queue_id)" do
        Alephant::Queue
          .should_receive(:new)
          .with(:sqs_queue_id)

        instance = subject.new({
          :sqs_queue_id => :sqs_queue_id
        })
      end
    end

    context "initializes @cache" do
      it "with Cache.new(@s3_bucket_id, @s3_object_path)" do
        Alephant::Cache
          .should_receive(:new)
          .with(:s3_bucket_id, :s3_object_path)

        instance = subject.new({
          :s3_bucket_id   => :s3_bucket_id,
          :s3_object_path => :s3_object_path
        })
      end
    end

    context "initializes @multi_renderer" do
      it "MultiRenderer class to be initialized" do
        Alephant::MultiRenderer
          .should_receive(:new)
          .with('foo', 'components')

        instance = subject.new({
          :view_path    => 'components',
          :component_id => 'foo'
        })
      end
    end
  end

  describe "run!" do
    before(:each) do
      sequencer      = double()
      queue          = double()
      cache          = double()
      multi_renderer = double()

      Alephant::Sequencer.stub(:create).and_return(sequencer)
      Alephant::Queue.any_instance.stub(:initialize).and_return(queue)
      Alephant::Cache.any_instance.stub(:initialize).and_return(cache)
      Alephant::MultiRenderer.any_instance.stub(:initialize).and_return(multi_renderer)
    end

    it "returns a Thread" do
      instance = subject.new({
        :sqs_queue_id => :sqs_queue_id
      })

      expect(instance.run!).to be_a(Thread)
    end

    it "calls @queue.poll" do
      instance = subject.new({
        :sqs_queue_id => :sqs_queue_id
      })

      instance.should_receive(:receive).with(:msg)

      expect_any_instance_of(Alephant::Queue)
        .to receive(:poll)
        .and_yield(:msg)

      t = instance.run!
      t.join
    end
  end

  describe "receive(msg)" do
    before(:each) do
      sequencer      = double()
      queue          = double()
      cache          = double()
      multi_renderer = double()

      Alephant::Queue.any_instance.stub(:initialize).and_return(queue)
      Alephant::Cache.any_instance.stub(:initialize).and_return(cache)
      Alephant::MultiRenderer.any_instance.stub(:initialize).and_return(multi_renderer)
    end

    it "writes data to cache if sequential order is true" do
      data = "{ \"foo\":\"bar\" }"

      msg = double()
      msg.stub(:id).and_return(:id)
      msg.stub(:md5).and_return(:md5)
      msg.stub(:body).and_return(data)

      Alephant::Sequencer::Sequencer
        .any_instance
        .stub(:sequential?)
        .and_return(true)

      Alephant::Sequencer::SequenceTable
        .any_instance
        .stub(:create)

      Alephant::Sequencer::Sequencer
        .any_instance
        .stub(:set_last_seen)

      instance = subject.new

      instance
        .should_receive(:write)
        .with(JSON.parse(data, :symbolize_names => true))

      instance.receive(msg)
    end
  end

  describe "write(data)" do
    before(:each) do
      sequencer = double()
      queue     = double()

      Alephant::Sequencer::Sequencer
        .any_instance
        .stub(:initialize)
        .and_return(sequencer)

      Alephant::Queue
        .any_instance
        .stub(:initialize)
        .and_return(queue)
    end

    it "puts rendered data into the S3 Cache" do
      templates = {
        :foo => 'content',
        :bar => 'content'
      }

      Alephant::Cache
        .any_instance
        .should_receive(:put)
        .with(:foo, templates[:foo])

      Alephant::Cache
        .any_instance
        .should_receive(:put)
        .with(:bar, templates[:bar])

      Alephant::MultiRenderer
        .any_instance
        .stub(:render)
        .and_return(templates)

      instance = subject.new({
        :s3_object_id => :s3_object_id
      })

      instance.write(:content)
    end
  end
end
