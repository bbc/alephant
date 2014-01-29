require 'faraday'
require 'uri'

module Alephant
  module Preview
    class Template

      def self.update(template_location)
        self.new.update(template_location)
      end

      def template
        response = Faraday.new(:url => host).get(path)
        raise "Can't get template" if response.status != 200

        apply_static_host_regex_to response.body
      end

      def update(template_location)
        File.open(template_location, 'w') { |file|
          file.write(template)
        }
      end

      def host
        "#{uri.scheme}://#{uri.host}"
      end

      def path
        uri.path
      end

      def uri
        return @uri if not @uri.nil?

        uri_from_env = ENV['PREVIEW_TEMPLATE_URL']
        raise Exception.new("PREVIEW_TEMPLATE_URL is unset!") if uri_from_env.nil?

        @uri = URI(uri_from_env)
      end

      def apply_static_host_regex_to(string)
        string.gsub(static_host_regex, '{{{static_host}}}')
      end

      def static_host_regex
        return @static_host_regex if not @static_host_regex.nil?

        static_host_regex_from_env = ENV['STATIC_HOST_REGEX']
        raise Exception.new("STATIC_HOST_REGEX is unset!") if static_host_regex_from_env.nil?

        @static_host_regex = Regexp.new(static_host_regex_from_env)
      end
    end
  end
end


