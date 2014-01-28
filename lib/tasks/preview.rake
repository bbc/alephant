require 'alephant/preview'
require_relative 'support/palpal'

namespace :alephant do
  namespace :preview do
    task :go do
      Alephant::Preview.run!
    end
    task :update do
      template_raw = PalPal::get_template
      template_location = "#{Dir.pwd}/views/templates/preview.mustache"
      File.open(template_location, 'w') { |file|
        file.write(template_raw)
      }
    end
  end
end

