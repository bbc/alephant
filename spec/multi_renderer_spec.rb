require 'spec_helper'

describe Alephant::MultiRenderer do
  subject { Alephant::MultiRenderer }

  describe "render(data)" do
    it "calls ::Alephant::renderer.render() for each template found" do
      templates = {
        :foo => 'content',
        :bar => 'content'
      }

      instance = subject.new

      instance.base_path = File.join(
        File.dirname(__FILE__),
        'fixtures',
        'views'
      )

      content = instance.render({ :foo => :bar })
      content.each do |template_type, rendered_content|
        expect(rendered_content).to eq(templates[template_type])
      end
    end
  end
end
