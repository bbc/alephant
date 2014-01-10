module Alephant::Views
  autoload :Base, 'alephant/views/base'

  @@views = {}

  def self.register(klass)
    id = klass.name.split('::').last
    @@views[id.underscore] = klass
  end

  def self.get_registered_class(id)
    @@views[id]
  end
end

