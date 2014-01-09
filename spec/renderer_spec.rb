require 'spec_helper'

describe Alephant::Renderer do
  let(:id) { :id }
  subject { Alephant::Renderer }

  describe "id=" do
    it "sets the attribute id" do
      expect(subject.new(id).id).to eq(id)
    end
  end

  describe "template(id)" do
    it "fails" do
      #fail
    end
  end

  describe "model(id, data)" do
    it "fails" do
      #fail
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
      it "should raise" do
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
