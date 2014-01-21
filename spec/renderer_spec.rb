require 'spec_helper'

describe Alephant::Renderer do
  let(:id) { :id }
  subject { Alephant::Renderer }

  describe "initialize(id, view_base_path=nil)" do
    context "id = :id" do
      it "sets the attribute id" do
        expect(subject.new(id).id).to eq(id)
      end
      context "view_base_path = '.'" do
        it "sets base_path" do
          expect(subject.new(id,'.').base_path).to eq('.')
        end
      end
    end
  end

  describe "template(id)" do
    let(:id) { 'example' }
    it "returns the template" do
      instance = subject.new(id)
      instance.base_path = File.join(
        File.dirname(__FILE__),
        'fixtures',
        'views'
      )

      template = instance.template(id)
      expect(template).to eq("{{content}}\n")
    end

    context 'invalid template' do
      let(:id) { 'invalid_example' }
      it 'should raise ViewTemplateNotFound' do
        instance = subject.new(id)
        instance.base_path = File.join(
          File.dirname(__FILE__),
          'fixtures',
          'views'
        )

        expect {
          instance.template(id)
        }.to raise_error(
          Alephant::Errors::ViewTemplateNotFound
        )
      end
    end
  end

  describe "model(id, data)" do
    let(:id) { 'example' }
    let(:data) { { :key => :value } }
    it "returns the model" do
      instance = subject.new(id)
      instance.base_path = File.join(
        File.dirname(__FILE__),
        'fixtures',
        'views'
      )

      model = instance.model(id, data)
      model.should be_an Alephant::Views::Base
      expect(model.data).to eq(data)
    end

    context "invalid model" do
      let(:id) { 'invalid_example' }
      it 'should raise ViewModelNotFound' do
        instance = subject.new(id)
        instance.base_path = File.join(
          File.dirname(__FILE__),
          'fixtures',
          'views'
        )
        expect {
          instance.model(id, data)
        }.to raise_error(
          Alephant::Errors::ViewModelNotFound
        )
      end
    end
  end

  describe "base_path" do
    it "should return DEFAULT_LOCATION" do
      expect(subject.new(id).base_path).to eq(
        Alephant::Renderer::DEFAULT_LOCATION
      )
    end

    context "base_path = '.'" do
      let(:base_path) { '.' }
      it "should return '.'" do
        instance = subject.new(id)
        instance.base_path = base_path
        expect(instance.base_path).to eq(base_path)
      end
    end
  end

  describe "base_path=(path)" do
    context "base_path = valid_path" do
      let(:valid_path) {'.'}
      it "should set the base_path" do
        instance = subject.new(id)
        instance.base_path = valid_path
        expect(instance.base_path).to eq(valid_path)
      end
    end

    context "base_path = invalid_path" do
      let(:invalid_path) {'./invalid_path'}
      it "should raise InvalidViewPath" do
        instance = subject.new(id)
        expect {
          instance.base_path = invalid_path
        }.to raise_error(
          Alephant::Errors::InvalidViewPath
        )
      end
    end
  end

  describe "render(data)" do
    it 'renders a template returned from template(id)' do
      Mustache.any_instance.stub(:render)
        .with(:template, :model).and_return(:content)
      Alephant::Renderer.any_instance.stub(:template)
        .with(id).and_return(:template)
      Alephant::Renderer.any_instance.stub(:model)
        .with(id, :data).and_return(:model)

      expect(subject.new(id).render(:data)).to eq(:content)
    end
  end
end
