require 'sinatra/base'

module Alephant
  class Preview < Sinatra::Base
    get '/component/:id/preview' do
      'hello world'
    end

  end
end
