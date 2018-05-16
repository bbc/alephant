# Alephant

The Alephant framework is a collection of isolated Ruby gems, which interconnect to offer powerful message passing functionality built up around the "Broker" pattern.

Alephant is being utilised by many different BBC teams and as the underlying framework for many different BBC based projects.

## Example application

To help new users get up and running with the Alephant framework more quickly and easily, we've provided an example application that mimics a similar pattern used within the BBC for different projects.

View the contents of the `Example` folder and follow the instructions in its README.

## Supported Rubies

- [MRI](https://www.ruby-lang.org/)
- [JRuby](http://jruby.org/)
- [Rubinius](http://rubini.us/)

## Alephant Gems

- [Alephant-Broker](https://github.com/BBC-News/alephant-broker)
- [Alephant-Harness](https://github.com/BBC-News/alephant-harness)
- [Alephant-Logger](https://github.com/BBC-News/alephant-logger)
- [Alephant-Logger-Cloudwatch](https://github.com/BBC-News/alephant-logger-cloudwatch)
- [Alephant-Logger-Json](https://github.com/BBC-News/alephant-logger-json)
- [Alephant-Logger-Statsd](https://github.com/BBC-News/alephant-logger-statsd)
- [Alephant-Lookup](https://github.com/BBC-News/alephant-lookup)
- [Alephant-Preview](https://github.com/BBC-News/alephant-preview)
- [Alephant-Publisher-Queue](https://github.com/BBC-News/alephant-publisher-queue)
- [Alephant-Publisher-Request](https://github.com/BBC-News/alephant-publisher-request)
- [Alephant-Renderer](https://github.com/BBC-News/alephant-renderer)
- [Alephant-Scout](https://github.com/BBC-News/alephant-scout)
- [Alephant-Sequencer](https://github.com/BBC-News/alephant-sequencer)
- [Alephant-Storage](https://github.com/BBC-News/alephant-storage)
- [Alephant-Support](https://github.com/BBC-News/alephant-support)

> Note: the [Alephant-Publisher](https://github.com/BBC-News/alephant-publisher) gem has been replaced by two new *publisher* gems: [Alephant-Publisher-Queue](https://github.com/BBC-News/alephant-publisher-queue) and [Alephant-Publisher-Request](https://github.com/BBC-News/alephant-publisher-request).

> Note: the [Alephant-Cache](https://github.com/BBC-News/alephant-cache) gem has been replaced by [Alephant-Storage](https://github.com/BBC-News/alephant-storage).

## Past life

In a past life this repository hosted a gem of the name Alephant (which you can still find linked to on [RubyGems](https://rubygems.org/gems/alephant)).

The gem has been deprecated in favour of an information portal, which will discuss the different gems available as part of the Alephant framework and provide details on how to utilise them.

We strongly recommend you no longer use the [Alephant gem](https://rubygems.org/gems/alephant) as it is deprecated.

## Contributing

1. [Fork it!](http://github.com/BBC-News/alephant/fork)
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Create new [Pull Request](https://github.com/BBC-News/alephant/pulls).
