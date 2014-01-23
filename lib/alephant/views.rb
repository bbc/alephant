require 'alephant/views/base'

module Alephant::Views
  @@views = {}

  def self.register(klass)
    id = klass.name.split('::').last
    @@views[id.underscore] = klass
  end

  def self.get_registered_class(id)
    @@views[id]
  end
end

