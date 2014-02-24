# Alephant

This is the main entry point for the Alephant framework.

## Installation

Add this line to your application's Gemfile:

    gem 'alephant'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install alephant

## Usage

```ruby
require 'alephant'
require 'configuration'

class App
  def initialize
    @config = Configuration.new
    @alephant = Alephant::Publisher.create(@config.app_config, logger)
  end

  def run!
    t = @alephant.run!
    t.join
  end

  def logger
    @logger ||= LoggerFactory.create(@config)
  end
end
```

## Contributing

1. Fork it ( http://github.com/BBC-News/alephant/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
