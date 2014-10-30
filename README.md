# Alephant

This is the main entry point for the Alephant framework.

Requires:

 - [alephant-broker](https://github.com/BBC-News/alephant-broker)       
 [![Build Status](https://travis-ci.org/BBC-News/alephant-broker.png?branch=master)](https://travis-ci.org/BBC-News/alephant-broker) [![Dependency Status](https://gemnasium.com/BBC-News/alephant-broker.png)](https://gemnasium.com/BBC-News/alephant-broker) [![Gem Version](https://badge.fury.io/rb/alephant-broker.png)](http://badge.fury.io/rb/alephant-broker)
 - [alephant-renderer](https://github.com/BBC-News/alephant-renderer)         
 [![Build Status](https://travis-ci.org/BBC-News/alephant-renderer.png?branch=master)](https://travis-ci.org/BBC-News/alephant-renderer) [![Dependency Status](https://gemnasium.com/BBC-News/alephant-renderer.png)](https://gemnasium.com/BBC-News/alephant-renderer) [![Gem Version](https://badge.fury.io/rb/alephant-renderer.png)](http://badge.fury.io/rb/alephant-renderer)
 - [alephant-support](https://github.com/BBC-News/alephant-support)       
 [![Build Status](https://travis-ci.org/BBC-News/alephant-support.png?branch=master)](https://travis-ci.org/BBC-News/alephant-support) [![Dependency Status](https://gemnasium.com/BBC-News/alephant-support.png)](https://gemnasium.com/BBC-News/alephant-support) [![Gem Version](https://badge.fury.io/rb/alephant-support.png)](http://badge.fury.io/rb/alephant-support)
 - [alephant-sequencer](https://github.com/BBC-News/alephant-sequencer)       
 [![Build Status](https://travis-ci.org/BBC-News/alephant-sequencer.png?branch=master)](https://travis-ci.org/BBC-News/alephant-sequencer) [![Dependency Status](https://gemnasium.com/BBC-News/alephant-sequencer.png)](https://gemnasium.com/BBC-News/alephant-sequencer) [![Gem Version](https://badge.fury.io/rb/alephant-sequencer.png)](http://badge.fury.io/rb/alephant-sequencer)
 - [alephant-cache](https://github.com/BBC-News/alephant-cache)       
 [![Build Status](https://travis-ci.org/BBC-News/alephant-cache.png?branch=master)](https://travis-ci.org/BBC-News/alephant-cache) [![Dependency Status](https://gemnasium.com/BBC-News/alephant-cache.png)](https://gemnasium.com/BBC-News/alephant-cache) [![Gem Version](https://badge.fury.io/rb/alephant-cache.png)](http://badge.fury.io/rb/alephant-cache)
 - [alephant-logger](https://github.com/BBC-News/alephant-logger)        
 [![Build Status](https://travis-ci.org/BBC-News/alephant-logger.png?branch=master)](https://travis-ci.org/BBC-News/alephant-logger) [![Dependency Status](https://gemnasium.com/BBC-News/alephant-logger.png)](https://gemnasium.com/BBC-News/alephant-logger) [![Gem Version](https://badge.fury.io/rb/alephant-logger.png)](http://badge.fury.io/rb/alephant-logger)
 - [alephant-lookup](https://github.com/BBC-News/alephant-lookup)      
 [![Build Status](https://travis-ci.org/BBC-News/alephant-lookup.png?branch=master)](https://travis-ci.org/BBC-News/alephant-lookup) [![Dependency Status](https://gemnasium.com/BBC-News/alephant-lookup.png)](https://gemnasium.com/BBC-News/alephant-lookup) [![Gem Version](https://badge.fury.io/rb/alephant-lookup.png)](http://badge.fury.io/rb/alephant-lookup)
 - [alephant-preview](https://github.com/BBC-News/alephant-preview)       
 [![Build Status](https://travis-ci.org/BBC-News/alephant-preview.png?branch=master)](https://travis-ci.org/BBC-News/alephant-preview) [![Dependency Status](https://gemnasium.com/BBC-News/alephant-preview.png)](https://gemnasium.com/BBC-News/alephant-preview) [![Gem Version](https://badge.fury.io/rb/alephant-preview.png)](http://badge.fury.io/rb/alephant-preview)

Deprecated:

 - [alephant-publisher](https://github.com/BBC-News/alephant-publisher)      
 [![Build Status](https://travis-ci.org/BBC-News/alephant-publisher.png?branch=master)](https://travis-ci.org/BBC-News/alephant-publisher) [![Dependency Status](https://gemnasium.com/BBC-News/alephant-publisher.png)](https://gemnasium.com/BBC-News/alephant-publisher) [![Gem Version](https://badge.fury.io/rb/alephant-publisher.png)](http://badge.fury.io/rb/alephant-publisher)

**Note**: the [alephant-publisher](https://github.com/BBC-News/alephant-publisher) gem has been replaced by two new *publisher* gems; [alephant-publisher-queue](https://github.com/BBC-News/alephant-publisher-queue) and [alephant-publisher-request](https://github.com/BBC-News/alephant-publisher-request). 

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

1. [Fork it!](http://github.com/BBC-News/alephant/fork)
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Create new [Pull Request](https://github.com/BBC-News/alephant/pulls).
