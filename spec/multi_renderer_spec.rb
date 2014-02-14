require 'spec_helper'

describe Alephant::MultiRenderer do
  let(:component_id) { :foo }
  let(:data) {{ :foo => :bar }}

  subject { Alephant::MultiRenderer }

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
          Alephant::Errors::InvalidViewPath
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
        expect(subject.new(component_id).base_path).to eq(Alephant::MultiRenderer::DEFAULT_LOCATION)
      end
    end
  end

  describe "render_template(template_file, data, instance = nil)" do
    context "instance is not nil" do
      it "renders the specified template" do
        Alephant::MultiRenderer.any_instance.stub(:create_instance)
        Alephant::Renderer::Mustache.any_instance.stub(:render).and_return('content')

        expect(
          subject.new(component_id, '.')
            .render_template('foo', data)
        ).to eq('content')
      end
    end
  end

  describe "render(data)" do
    it "calls render_template for each template found" do
      Alephant::MultiRenderer.any_instance.stub(:render_template)
      Alephant::MultiRenderer.any_instance.stub(
        :template_locations
      ).and_return(['foo', 'bar'])

      expect(
        subject.new(component_id, '.').render(data).size
      ).to eq(2)
    end
  end

  describe "create_instance(template_file, data)" do
    it "returns the model" do
      model = subject.new(
        component_id,
        'fixtures/components'
      ).create_instance('foo', data)

      model.should be_an Alephant::Views::Base
      expect(model.data).to eq(data)
    end

    context "invalid model" do
      it 'should raise ViewModelNotFound' do
        expect {
          subject.new(
            component_id,
            @base_path
          ).create_instance(
            'invalid_model',
            data
          )
        }.to raise_error(
          Alephant::Errors::ViewModelNotFound
        )
      end
    end
  end
end
