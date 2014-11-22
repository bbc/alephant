require "alephant/publisher/queue"
require "alephant/renderer/views/html"
require "alephant/renderer/views/json"
require "alephant/logger"
require_relative "env"

module App
  include Alephant::Logger

  def self.run!
    loop do
      begin
        Alephant::Publisher::Queue.create(options).run!
      rescue Exception => e
        logger.warn "Error: #{e.message}\n#{e.backtrace.join("\n")}"
      end
    end
  end

  private

  def self.app_config
    BBC::Cosmos::Config.app
  end

  def self.component_base_path
    File.join(File.dirname(__FILE__), "components")
  end

  def self.options
    Alephant::Publisher::Queue::Options.new.tap do |opts|
      opts.add_queue(
        :sqs_queue_name       => ENV["SQS_QUEUE_NAME"]
      )

      opts.add_writer(
        :sequencer_table_name => ENV['SEQUENCER_TABLE_NAME'],
        :lookup_table_name    => ENV['LOOKUP_TABLE_NAME'],
        :sequence_id_path     => ENV["SEQUENCE_ID_PATH"],
        :renderer_id          => ENV["RENDERER_ID"],
        :s3_bucket_id         => ENV["S3_BUCKET_ID"],
        :s3_object_path       => ENV["S3_OBJECT_PATH"],
        :view_path            => component_base_path
      )
    end
  end
end

App.run!
