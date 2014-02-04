require 'spec_helper'

describe Alephant::MultiRenderer do
  let(:model_file) { 'foo' }
  subject { Alephant::MultiRenderer }

  before(:each) do
      @instance = subject.new(model_file)
      @instance.base_path = File.join(
        File.dirname(__FILE__),
        'fixtures',
        'components',
        'foo'
      )
  end

  describe ".initialize(view_base_path)" do
    context "view_base_path = nil" do
      it "sets base_path" do
        expect(subject.new(model_file).base_path).to eq(Alephant::MultiRenderer::DEFAULT_LOCATION)
      end
    end

    context "view_base_path = '.'" do
      it "sets base_path" do
        expect(subject.new(model_file, '.').base_path).to eq('.')
      end
    end

    context "view_base_path = invalid_path" do
      it "should raise InvalidViewPath" do
        expect {
          instance = subject.new(model_file, './invalid_path')
        }.to raise_error(
          Alephant::Errors::InvalidViewPath
        )
      end
    end
  end

  describe "#render_template(template_file, data, instance = nil)" do
    context "instance is not nil" do
      let(:data) { { :foo => :bar } }
      let(:model_instance) { @instance.create_instance(data) }
      it "renders the specified template" do
        expect(
          @instance.render_template('foo', data, model_instance)
        ).to eq('content')
      end
    end

    context "instance is nil" do
      let(:data) { { :foo => :bar } }
      it "renders the specified template" do
        expect(
          @instance.render_template('foo', data, nil)
        ).to eq('content')
      end
    end


  end

  describe "#render(data)" do
    it "calls ::Alephant::renderer.render() for each template found" do
      templates = {
        :foo => 'content',
        :bar => 'content'
      }

      content = @instance.render({ :foo => :bar })
      content.each do |template_type, rendered_content|
        expect(rendered_content).to eq(templates[template_type])
      end
    end
  end

  describe "#create_instance(data)" do
    let(:data) {{ :key => :value }}

    it "returns the model" do
      model = @instance.create_instance(data)
      model.should be_an Alephant::Views::Base
      expect(model.data).to eq(data)
    end

    context "invalid model" do
      it 'should raise ViewModelNotFound' do
        instance = subject.new('invalid_model_file', @base_path)

        expect {
          instance.create_instance(data)
        }.to raise_error(
          Alephant::Errors::ViewModelNotFound
        )
      end
    end
  end
end
