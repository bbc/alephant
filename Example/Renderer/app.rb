require "alephant/publisher/queue"
require "alephant/renderer/views/html"
require "alephant/renderer/views/json"
require "alephant/logger"
require "bbc/cosmos/config"

module App

  def self.app_config
    BBC::Cosmos::Config.app
  end

  def self.component_base_path
    File.join(File.dirname(__FILE__), "components")
  end

  def self.options
    Alephant::Publisher::Queue::Options.new.tap do |opts|
      opts.add_queue(
        :sqs_queue_name => "election-data-renderer"
      )

      opts.add_writer(
        :sequencer_table_name => "development_sequencer",
        :lookup_table_name    => "development_lookup",
        :sequence_id_path     => "$.sequence",
        :renderer_id          => "test",
        :s3_bucket_id         => "election-data-shared",
        :s3_object_path       => "election-data-shared/development/html",
        :view_path            => component_base_path
      )
    end
  end

  def self.run!
    loop do
      begin
        Alephant::Publisher::Queue.create(options).run!
      rescue Exception => e
        error_message = "#{e.message}\n#{e.backtrace.join("\n")}"

        Alephant::Logger.get_logger.warn "Error: #{error_message}"
      end
    end
  end
end
