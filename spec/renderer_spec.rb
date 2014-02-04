require 'spec_helper'

describe Alephant::Renderer do
  let(:template_file) { 'foo' }
  let(:base_path) { :base_path }
  let(:model) { :model }
  subject { Alephant::Renderer }

  before(:each) do
    @base_path = File.join(
      File.dirname(__FILE__),
      'fixtures',
      'views'
    )
  end

  describe "initialize(template_file, base_path, model)" do
    context "template_file = :template_file" do
      it "sets the attribute template_file" do
        expect(subject.new(template_file, base_path, model).template_file).to eq(template_file)
      end
    end
  end

  describe "template()" do
    it "returns the template" do
      instance = subject.new(template_file, @base_path, model)
      template = instance.template
      expect(template).to eq("{{content}}\n")
    end

    context 'invalid template' do
      it 'should raise ViewTemplateNotFound' do
        instance = subject.new('invalid_example', @base_path, model)

        expect {
          instance.template
        }.to raise_error(
          Alephant::Errors::ViewTemplateNotFound
        )
      end
    end
  end

  describe "render()" do
    it 'renders a template returned from template(template_file)' do
      Mustache
        .any_instance
        .stub(:render)
        .with(:template, :model)
        .and_return(:content)

      Alephant::Renderer
        .any_instance
        .stub(:template)
        .and_return(:template)

      expect(subject.new(template_file, @base_path, model).render).to eq(:content)
    end
  end
end
