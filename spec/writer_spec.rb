require 'spec_helper'

describe Alephant::Writer do
  before(:each) do
    Alephant::RenderMapper.any_instance.stub(:initialize)
    Alephant::Cache.any_instance.stub(:initialize)
  end
  subject do
    Alephant::Writer.new({
      :renderer_id => 'renderer_id',
      :lookup_table_name => 'lookup_table_name'
    })
  end
  describe "#write(data, version)" do
    before(:each) do
      Alephant::RenderMapper.any_instance
        .stub(:generate)
        .and_return({
          'component_id' => Struct.new(:render).new('content')
        })

    end

    it "should write the correct lookup location" do
      options = { :key => :value }
      data = { :options => options }

      Alephant::Cache.any_instance
        .stub(:put)
      Alephant::Lookup
        .should_receive(:create)
        .with('lookup_table_name', 'component_id')
        .and_call_original
      Alephant::Lookup::Lookup.any_instance
        .stub(:initialize)
      Alephant::Lookup::Lookup.any_instance
        .should_receive(:write)
        .with(options, 'renderer_id/component_id/0')

      subject.write(data, 0)
    end

    it "should put the correct location, content to cache" do
      Alephant::Lookup::Lookup.any_instance.stub(:initialize)
      Alephant::Lookup::Lookup.any_instance.stub(:write)
      Alephant::Cache.any_instance
        .should_receive(:put).with('renderer_id/component_id/0', 'content')

      subject.write({}, 0)
    end
  end
end
