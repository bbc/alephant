require 'spec_helper'

describe Alephant::MultiRenderer do
  subject { Alephant::MultiRenderer }

  describe "render(data)" do
    it "calls ::Alephant::renderer.render() for each template found" do
      templates = {
        :responsive  => 'rendered_responsive_data',
        :holepunched => 'rendered_holepunched_data'
      }

      Alephant::MultiRenderer
        .any_instance
        .stub(:model)
        .and_return()

      Alephant::Renderer
        .any_instance
        .stub(:render)
        .with(:responsive)
        .and_return(templates[:responsive])

      Dir.stub_chain(:glob, :map).and_return([
        'responsive',
        'holepunched'
      ])

      instance = subject.new
      content = instance.render({ :foo => :bar })

      content.each_with_index do |template_type, rendered_content|
        expect(rendered_content).to eq(templates[template_type])
      end
    end
  end
end
