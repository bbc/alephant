require 'alephant'

class Test
  extend Alephant::AOP

  def test_method(arg)
    'test_return'
  end

end
