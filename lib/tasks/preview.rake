require 'alephant/preview'

namespace :alephant do
  task :preview do
    Alephant::Preview.run!
  end
end

