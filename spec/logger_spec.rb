require 'spec_helper'

describe Alephant::LogSystem do
  before(:each) do
    sequencer = double()
    queue     = double()
    cache     = double()
    renderer  = double()

    Alephant::Sequencer.any_instance.stub(:initialize).and_return(sequencer)
    Alephant::Queue.any_instance.stub(:initialize).and_return(queue)
    Alephant::Cache.any_instance.stub(:initialize).and_return(cache)
    Alephant::Renderer.any_instance.stub(:initialize).and_return(renderer)
  end

  after(:each) do
    Alephant.logger = nil
  end

  let (:instance) { Alephant::Alephant }
  subject { Alephant::LogSystem }

  describe "::Alephant::LogSystem.logger" do
    context "Logger not provided" do
      it "return Ruby built-in Logger" do
        instance.new
        expect(Alephant.logger.class).to be(Logger)
      end
    end

    context "Logger provided" do
      it "return custom Logger" do
        class FakeLogger; end
        instance.new({}, FakeLogger.new)
        expect(Alephant.logger.class).to be(FakeLogger)
      end
    end
  end
end

