require 'spec_helper'

describe Alephant::RenderMapper do
  let(:component_id) { :foo }
  let(:data) {{ :foo => :bar }}
  let(:path) { File.join(File.dirname(__FILE__), 'fixtures/components') }

  subject { Alephant::RenderMapper }

  before(:each) do
    File.stub(:directory?).and_return(true)
  end

  describe "initialize(view_base_path)" do
    context "view_base_path = invalid_path" do
      it "should raise InvalidViewPath" do
        File.stub(:directory?).and_return(false)
        expect {
          subject.new(component_id, './invalid_path')
        }.to raise_error(
          'Invalid path'
        )
      end
    end

    context "view_base_path = '.'" do
      it "sets base_path" do
        expect(subject.new(component_id, '.').base_path).to eq("./#{component_id}")
      end
    end

    context "view_base_path = nil" do
      it "sets base_path" do
        expect(subject.new(component_id).base_path).to eq(Alephant::RenderMapper::DEFAULT_LOCATION)
      end
    end
  end

  describe "create_renderer(template_file, data)" do
    it "Returns a valid renderer" do
      expect(
        subject.new(component_id, path)
          .create_renderer('foo', { :content => 'hello'})
      ).to be_a(Alephant::Renderer::Mustache)
    end

    it  "Returns expected rendered content from a render" do
      expect(
        subject.new(component_id, path)
          .create_renderer('foo', { :content => 'hello'}).render
      ).to eq("hello\n")

    end
  end

  describe "generate(data)" do
    it "calls create_renderer for each template found" do
      expect(
        subject.new(component_id, path).generate(data).size
      ).to eq(2)
    end
  end
end
