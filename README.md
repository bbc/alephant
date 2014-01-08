alephant
=========

[![Code Climate](https://codeclimate.com/repos/52cd866de30ba018f10000a2/badges/5d9c02131201565a630e/gpa.png)](https://codeclimate.com/repos/52cd866de30ba018f10000a2/feed)

Static publishing to s3 on push notification from SQS

##Dependencies

- JRuby 1.7.8
- An AWS account

##Setup

Ensure you have a `config/aws.yml` in the format:
```yaml
access_key_id: ACCESS_KEY_ID
secret_access_key: SECRET_ACCESS_KEY
```
Install the gem dependencies:
`bundle install`

##Usage
Start the Queue Loader to load dummy data into the queue:
`ruby load_queue.rb`

Start the render to cache application:
`./bin/alephant.rb`

##Usage as a jar
`warble compiled jar`

###Running the service
`java -jar alephant.jar`

