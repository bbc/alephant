require "alephant/version"
require "alephant/publisher"

module Alephant
  # Consuming application calls: `Alephant::Publisher.create`

  module AOP

    def around(fn_name)
      puts 'In around method'
      old_method = instance_method(fn_name)
      define_method(fn_name) do |*args|
        yield :before, args if block_given?
        old_method.bind(self).call(args).tap do |return_value|
          args << return_value unless return_value.nil?
        end
        yield :after, args if block_given?
      end
    end

  end
end
