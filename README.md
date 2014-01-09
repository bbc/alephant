alephant
=========

Static publishing to S3 on push notification from SQS

[![Code Climate](https://codeclimate.com/repos/52cd866de30ba018f10000a2/badges/5d9c02131201565a630e/gpa.png)](https://codeclimate.com/repos/52cd866de30ba018f10000a2/feed)

[![Build Status](https://travis-ci.org/kenoir/alephant.png?branch=master)](https://travis-ci.org/kenoir/alephant)

[![Gem Version](https://badge.fury.io/rb/alephant.png)](http://badge.fury.io/rb/alephant)

##Dependencies

- JRuby 1.7.8
- An AWS account

##Setup

Ensure you have a `config/aws.yml` in the format:
```yaml
access_key_id: ACCESS_KEY_ID
secret_access_key: SECRET_ACCESS_KEY
```

Install the gem:
```sh
gem install alephant
```

In your application:
```rb
require 'alephant'

Alephant.run('your_cache_id')
```

