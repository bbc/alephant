$: << "."

require "env"
require "crimp"
require "alephant/renderer"
require "alephant/cache"
require "alephant/lookup"
require "alephant/sequencer"

class App
  def self.poll_queue
    queue.poll do |msg|
      @@data   = parse msg.body

      get_sequence.validate(msg) do
        version  = seq_id_for msg
        location = component_key version

        s3.put location, rendered_content, "text/html"
        lookup.write(component_name, variant, version, location)
      end
    end
  end

  def self.get_sequence
    Alephant::Sequencer.create(
      ENV["DYNAMO_SQ"],
      sequencer_key,
      config[:msg_seq_path]
    )
  end

  def self.component_key(version)
    "#{sequencer_key}/#{version}"
  end

  def self.sequencer_key
    "#{template_name}/#{create_key}"
  end

  def self.queue
    @@queue ||= sqs.queues.named(ENV["SQS_QUEUE"])
  end

  def self.sqs
    @@sqs ||= AWS::SQS.new
  end

  def self.rendered_content
    Alephant::Renderer.create(
      config, @@data
    ).views[template_name].render
  end

  def self.config
    {
      :renderer_id  => component_name,
      :view_path    => "components",
      :msg_seq_path => "$.sequence"
    }
  end

  def self.component_name
    @@data[:component]
  end

  def self.template_name
    "#{component_name}_example"
  end

  def self.parse(data)
    JSON.parse data, :symbolize_names => true
  end

  def self.s3
    Alephant::Cache.new(ENV["S3_BUCKET"], component_name)
  end

  def self.variant
    @@data.fetch(:variant, {})
  end

  def self.create_key
    Crimp.signature variant
  end

  def self.lookup
    @@lookup ||= Alephant::Lookup.create(ENV["DYNAMO_LU"])
  end

  def self.seq_id_for(message)
    Alephant::Sequencer::Sequencer.sequence_id_from(message, config[:msg_seq_path])
  end
end

App.poll_queue
