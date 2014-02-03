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

# describe "base_path" do
#   it "should return DEFAULT_LOCATION" do
#     expect(subject.new(template_file).base_path).to eq(
#       Alephant::Renderer::DEFAULT_LOCATION
#     )
#   end

#   context "base_path = '.'" do
#     let(:base_path) { '.' }
#     it "should return '.'" do
#       instance = subject.new(template_file, base_path, model)
#       expect(instance.base_path).to eq(base_path)
#     end
#   end
# end

# describe "base_path=(path)" do
  # context "base_path = valid_path" do
  #   let(:valid_path) {'.'}
  #   it "should set the base_path" do
  #     instance = subject.new(template_file, valid_path, model)
  #     expect(instance.base_path).to eq(valid_path)
  #   end
  # end

  # context "base_path = invalid_path" do
  #   let(:invalid_path) {'./invalid_path'}
  #   it "should raise InvalidViewPath" do
  #     instance = subject.new(template_file, base_path, model)
  #     expect {
  #       instance.base_path = invalid_path
  #     }.to raise_error(
  #       Alephant::Errors::InvalidViewPath
  #     )
  #   end
  # end
# end

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
