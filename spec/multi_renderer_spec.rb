
require 'spec_helper'

describe Alephant::MultiRenderer do
  let(:component_id) { :foo }
  subject { Alephant::MultiRenderer }

  describe "initialize(view_base_path)" do
    context "view_base_path = invalid_path" do
      it "should raise InvalidViewPath" do
        expect {
          instance = subject.new(component_id, './invalid_path')
        }.to raise_error(
          Alephant::Errors::InvalidViewPath
        )
      end
    end

    context "view_base_path = '.'" do
      it "sets base_path" do
        File.stub(:directory?).and_return(true)
        expect(subject.new(component_id, '.').base_path).to eq("./#{component_id}")
      end
    end

    context "view_base_path = nil" do
      it "sets base_path" do
        expect(subject.new(component_id).base_path).to eq(Alephant::MultiRenderer::DEFAULT_LOCATION)
      end
    end
  end

  describe "render_template(template_file, data, instance = nil)" do
    before(:each) do
      File.stub(:directory?).and_return(true)
    end

    context "instance is not nil" do
      let(:data) {{ :foo => :bar }}

      it "renders the specified template" do
        Alephant::MultiRenderer.any_instance.stub(:create_instance)
        Alephant::Renderer.any_instance.stub(:render).and_return('content')

        expect(
          subject.new(component_id, '.')
            .render_template('foo', data)
        ).to eq('content')
      end
    end
  end

  describe "render(data)" do
    before(:each) do
      File.stub(:directory?).and_return(true)
    end

    it "calls ::Alephant::renderer.render() for each template found" do
      Alephant::MultiRenderer.any_instance.stub(:create_instance)
      Alephant::Renderer.any_instance.stub(:render).and_return('content')

      Dir.stub(:glob).and_return(['/some/path/foo.mustache', '/some/path/bar.mustache'])

      templates = {
        :foo => 'content',
        :bar => 'content'
      }

      instance = subject.new(component_id, '.')

      content = instance.render({ :foo => :bar })

      expect(content.size).to eq(2)

      content.each do |template_type, rendered_content|
        expect(rendered_content).to eq(templates[template_type])
      end
    end
  end

  describe "create_instance(template_file, data)" do
    before(:each) do
      File.stub(:directory?).and_return(true)
    end

    let(:data) {{ :key => :value }}

    it "returns the model" do
      instance = subject.new(component_id, 'fixtures/components')
      model = instance.create_instance(data, 'foo')
      model.should be_an Alephant::Views::Base
      expect(model.data).to eq(data)
    end

    context "invalid model" do
      it 'should raise ViewModelNotFound' do
        instance = subject.new(component_id, @base_path)

        expect {
          instance.create_instance(data, 'invalid_model')
        }.to raise_error(
          Alephant::Errors::ViewModelNotFound
        )
      end
    end
  end
end
