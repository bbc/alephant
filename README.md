# Alephant

The Alephant framework is a collection of isolated Ruby gems, which interconnect to offer powerful message passing functionality built up around the "Broker" pattern. 

Alephant is being utilised by many different BBC teams and as the underlying framework for many different BBC based projects.

## TODO

Provide a simple example application so users can get up and running with the Alephant framework much more quickly and easily; as well as providing architectural diagrams and details for each individual Alephant gem.

We will also aim to include information regarding the architectural pattern the Alephant framework is based upon.

## Supported Rubies

- [MRI](https://www.ruby-lang.org/)
- [JRuby](http://jruby.org/)
- [Rubinius](http://rubini.us/)

## Alephant Gems

- [Alephant-Broker](https://github.com/BBC-News/alephant-broker)
- [Alephant-Cache](https://github.com/BBC-News/alephant-cache) (soon to be renamed "Alephant-Storage")
- [Alephant-Harness](https://github.com/BBC-News/alephant-harness)
- [Alephant-Logger](https://github.com/BBC-News/alephant-logger)
- [Alephant-Lookup](https://github.com/BBC-News/alephant-lookup)
- [Alephant-Preview](https://github.com/BBC-News/alephant-preview)
- [Alephant-Publisher](https://github.com/BBC-News/alephant-publisher) (deprecated)
- [Alephant-Publisher-Queue](https://github.com/BBC-News/alephant-publisher-queue)
- [Alephant-Publisher-Request](https://github.com/BBC-News/alephant-publisher-request)
- [Alephant-Renderer](https://github.com/BBC-News/alephant-renderer)
- [Alephant-Scout](https://github.com/BBC-News/alephant-scout)
- [Alephant-Sequencer](https://github.com/BBC-News/alephant-sequencer)
- [Alephant-Support](https://github.com/BBC-News/alephant-support)

> Note: the [alephant-publisher](https://github.com/BBC-News/alephant-publisher) gem has been replaced by two new *publisher* gems: [alephant-publisher-queue](https://github.com/BBC-News/alephant-publisher-queue) and [alephant-publisher-request](https://github.com/BBC-News/alephant-publisher-request). 

### Interlinked...

The following mind map demonstrates how each of the gems (currently available) within the Alephant framework are linked together.

![alephant mind map](https://cloud.githubusercontent.com/assets/180050/5049794/560519a0-6c20-11e4-8ac4-302ee02352cc.png)

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
