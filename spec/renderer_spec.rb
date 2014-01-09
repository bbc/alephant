require 'spec_helper'

describe Alephant::Renderer do
  let(:id) { :id }
  subject { Alephant::Renderer }
  it "sets the attribute id" do
    expect(subject.new(id).id).to eq(id)
  end

  describe "render(data)" do
    it 'renders a template returned from template(id)' do
      Mustache.any_instance.stub(:render)
        .with(:template, :data).and_return(:content)
      Alephant::Renderer.any_instance.stub(:template)
        .with(id).and_return(:template)

      expect(subject.new(id).render(:data)).to eq(:content)
    end
  end
end
