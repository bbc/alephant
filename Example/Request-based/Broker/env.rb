require 'aws-sdk-dynamodb'
require 'dotenv'

ENV['APP_ENV']      = ENV.fetch('APP_ENV', 'development')
ENV['DEV_APP_CONF'] = File.join(File.dirname(__FILE__), 'config', 'development', 'app.json')

if ENV['APP_ENV'] == 'development'
  require 'pry'
  require 'spurious/ruby/awssdk/helper'
  Spurious::Ruby::Awssdk::Helper.configure
end

Dotenv.load(
  File.join(
    File.dirname(__FILE__), 'config', ENV['APP_ENV'], 'env.yaml'
  )
)
