$: << "."

require "env"
require "crimp"
require "alephant/renderer"

class App
  def self.poll_queue
    queue.poll do |msg|
      data = parse msg.body
      bucket.objects[create_key_from data].write(render data)
    end
  end

  def self.queue
    @@queue ||= sqs.queues.named(ENV["SQS_QUEUE"])
  end

  def self.sqs
    @@sqs ||= AWS::SQS.new
  end

  def self.render(data)
    binding.pry
    Alephant::Renderer.create(config(data), data).views["#{data[:component]}_example"].render
  end

  def self.config(data)
    {
      :renderer_id => data[:component],
      :view_path   => "components"
    }
  end

  def self.template(component)
    IO.read "templates/#{component}.mustache"
  end

  def self.parse(data)
    JSON.parse data, :symbolize_names => true
  end

  def self.s3
    @@s3 ||= AWS::S3.new
  end

  def self.bucket
    @@bucket ||= s3.buckets[ENV["S3_BUCKET"]]
  end

  def self.create_key_from(data)
    "#{data[:component]}/#{Crimp.signature(data.fetch(:variant, {}))}"
  end
end

App.poll_queue
