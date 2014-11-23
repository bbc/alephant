$: << "."

require "env"
require "crimp"
require "alephant/renderer"
require "alephant/cache"

class App
  def self.poll_queue
    queue.poll do |msg|
      data = parse msg.body
      s3(data).put create_key_from(data), render(data), "text/html"
    end
  end

  def self.queue
    @@queue ||= sqs.queues.named(ENV["SQS_QUEUE"])
  end

  def self.sqs
    @@sqs ||= AWS::SQS.new
  end

  def self.render(data)
    Alephant::Renderer.create(
      config(data), data
    ).views[view data].render
  end

  def self.config(data)
    {
      :renderer_id => data[:component],
      :view_path   => "components"
    }
  end

  def self.view(data)
    "#{data[:component]}_example"
  end

  def self.template(component)
    IO.read "templates/#{component}.mustache"
  end

  def self.parse(data)
    JSON.parse data, :symbolize_names => true
  end

  def self.s3(data)
    Alephant::Cache.new(ENV["S3_BUCKET"], data[:component])
  end

  def self.create_key_from(data)
    Crimp.signature(
      data.fetch(:variant, {})
    )
  end
end

App.poll_queue
