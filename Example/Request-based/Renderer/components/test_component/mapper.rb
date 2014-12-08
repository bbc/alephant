require 'alephant/publisher/request/data_mapper'

class TestComponentMapper < Alephant::Publisher::Request::DataMapper
  def data
    get '/'
  end
end
