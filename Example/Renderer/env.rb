require "aws-sdk"
require "dotenv"

ENV["APP_ENV"] = ENV.fetch("APP_ENV", "development")

if ENV["APP_ENV"] == "development"
  require "pry"
  require "spurious/ruby/awssdk/helper"
  Spurious::Ruby::Awssdk::Helper.configure
end

Dotenv.load(
  File.join(
    File.dirname(__FILE__), "config", ENV["APP_ENV"], "env.yaml"
  )
)

