## Alephant example application

This example is made up of three separate applications:

1. Sender
2. Renderer
3. Broker

```
----------                ---------              ------------     ----------
| Sender | -- message --> | Queue | <-- poll --> | Renderer | --> | Bucket |
----------                ---------              ------------     ----------

----------                ----------                          ----------
| Client | -- request --> | Broker | <-- retrieve content --> | Bucket |
----------                ----------                          ----------
```

### Sender

The Sender's role is to send JSON data as a message (at random) to an AWS SQS queue.

### Renderer

The Renderer's role is to poll the same AWS SQS queue as the Sender is using, and to retrieve any messages found, render their JSON into a HTML template and to store the rendered HTML into an AWS S3 bucket.

The Renderer application utilises the following Alephant gems:

- [alephant-renderer](https://github.com/BBC-News/alephant-renderer)
- [alephant-cache](https://github.com/BBC-News/alephant-cache)
- [alephant-lookup](https://github.com/BBC-News/alephant-lookup)
- [alephant-sequencer](https://github.com/BBC-News/alephant-sequencer)

### Broker

The Broker's role is to accept requests from a client (this could be a `curl` HTTP request or from a web browser) and to negotiate which content from inside the AWS S3 bucket should be returned.

## Running each application

Each application is reliant on Spurious (see below) running in the background.

Otherwise, the Renderer can be run by itself and it'll simply sit and wait for messages to appear on the queue before doing anything. Similarly, if you run the Sender by itself it'll simply send pre-defined messages to the queue. 

When running the Broker, it simply sits and waits for incoming requests and then tries to retrieve the relevant content from S3 (if it doesn't exist - i.e. you haven't sent any messages and so nothing has been rendered - then the Broker will return a 500 along with a stack trace error).

> Note: the Broker wont be able to access the Spurious AWS resources (e.g. S3 bucket, DynamoDB tables) unless we run the Renderer first. This is because the S3 set-up of those resources (i.e. `rake harness`) wont have happened and so the code might error whilst running the broker (e.g. it'll try to access a resource that doesn't exist yet in Spurious)

### Spurious

Spurious allows us to develop against locally running versions of specific AWS resources (such as S3, DynamoDB and SQS).

> Note: there is a bug with the Docker-API gem that currently requires version < 1.15.0

Spurious is built using [Docker](https://www.docker.com/) and so it requires Docker to be running. If you're running this code on a Mac then you'll need to use [Boot2Docker](http://boot2docker.io/) (a lightweight Linux VM) so please make sure you have both these dependencies installed first.

1. `boot2docker init`
2. `boot2docker up` (check status: `boot2docker status` and `docker ps -a`)
3. `spurious-server start` (check status: `spurious-server status`)
4. `spurious init`
5. `spurious up` (check status: `spurious ports`)

> Note: once Boot2Docker and Spurious are running, the following applications (Sender, Renderer and Broker) will all be able to utilise the single running instance of Spurious.

### Spurious Browser

Spurious also provides a visual browser which allows you an easier way to view what content each supported AWS resource contains: [https://github.com/stevenjack/spurious-browser](https://github.com/stevenjack/spurious-browser).

The browser is a Ruby Rack application and can be run by following these steps:

1. `cd ~/`
2. `git clone https://github.com/stevenjack/spurious-browser.git`
3. `cd spurious-browser`
4. `rackup`
5. Visit `http://localhost:9292/` and enter the relevant credentials defined in `{Broker|Renderer|Sender}/config/development/env.yaml`

### Sender

1. `cd Sender`
2. `bundle install`
3. `rake harness` (sets up SQS queue based on `config/{env}/env.yaml`)
4. `ruby app.rb`

### Renderer

1. `cd Renderer`
2. `bundle install`
3. `rake harness` (sets up S3 bucket based on `config/{env}/env.yaml`)
4. `ruby app.rb`

### Broker

1. `cd Broker`
2. `bundle install`
3. `bundle exec rackup -s puma -p 9293`
4. `curl http://0.0.0.0:9293/component/foo`

> Note: the `curl` command will depend on what messages you sent and were renderered. So in our Sender application we fire off messages which have a `component` key set to either "test", "foo" or "bar". In the above `curl` example I'm requesting the foo component