alephant
=========

Static publishing to S3 on push notification from SQS

[![Code Climate](https://codeclimate.com/repos/52d6bec56956802e26011a0f/badges/fce457795179641460e0/gpa.png)](https://codeclimate.com/repos/52d6bec56956802e26011a0f/feed)

[![Build Status](https://travis-ci.org/BBC-News/alephant.png?branch=master)](https://travis-ci.org/BBC-News/alephant)

[![Dependency Status](https://gemnasium.com/BBC-News/alephant.png)](https://gemnasium.com/BBC-News/alephant)

[![Gem Version](https://badge.fury.io/rb/alephant.png)](http://badge.fury.io/rb/alephant)

##Dependencies

- JRuby 1.7.8
- An AWS account (you'll need to create):
  - An S3 bucket
  - An SQS Queue
  - A Dynamo DB table (optional, will attempt to create if can't be found)

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
opts = {
  :s3_bucket_id => 'bucket-id',
  :s3_object_path => 'path/to/object',
  :s3_object_id => 'object_id',
  :table_name => 'your_dynamo_db_table',
  :sqs_queue_id => 'https://your_amazon_sqs_queue_url',
  :view_id => 'my_view_id',
  :sequential_proc => Proc.new { |last_seen_id, data|
    last_seen_id < data["sequence_id"].to_i
  },
  :set_last_seen_proc => Proc.new { |data|
    data["sequence_id"].to_i
  }
}

thread = Alephant::Alephant.new(opts).run!
thread.join
```

Provide a view in a folder:

```
└── views
    ├── models
    │   └── foo.rb
    └── templates
        └── foo.mustache
```

**SQS Message Format**

```json
{
  "content": "hello world",
  "sequential_id": 1
}
```

**foo.rb**
```rb
module MyApp
  module Views
    class Foo < Alephant::Views::Base
      def content
        @data['content']
      end
    end
  end
end
```

**foo.mustache**
```mustache
{{content}}
```

**S3 Output**
```
hello world
```

