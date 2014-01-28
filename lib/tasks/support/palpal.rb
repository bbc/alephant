module PalPal
  require 'faraday'

  TEMPLATE_HOST = ENV['TEMPLATE_HOST'] || "http://pal.sandbox.dev.bbc.co.uk"
  TEMPLATE_PATH = "/news/layout/template"

  def self.get_template(host = PalPal::TEMPLATE_HOST)
    conn = Faraday.new(:url => host)
    response = conn.get(PalPal::TEMPLATE_PATH)

    raise "Can't get template" if response.status != 200

    response.body
      .gsub(/static\.(sandbox\.dev|int|test|stage|live)\.bbc(i)?\.co\.uk\/news\/(dev|[^\/]+)/, '{{{static_host}}}')
  end

end
