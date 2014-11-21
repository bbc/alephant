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

### Broker

The Broker's role is to accept requests from a client (this could be a `curl` HTTP request or from a web browser) and to negotiate which content from inside the AWS S3 bucket should be returned.

## Running each application

You'll need to start each application in the order they appear below. So start the Sender first and then the Renderer - once all messages have been rendered then start up the Broker (in a real world application you wouldn't have to worry about starting the Broker *after* some messages have been rendered because you would have designed the client application - which makes requests to the Broker - to handle cases where no data was available; but this is a simplified project that takes the "happy path" for the same of simplicity and understanding).

Note: if Boot2Docker or Spurious are already running then you can skip the following steps that demonstrates how to run them

### Sender

> Note: the Sender application doesn't need to be a Rack app (TODO: fix that)

1. `cd Sender`
2. `bundle install`
3. `boot2docker init`
4. `boot2docker up` (check status: `boot2docker status` and `docker ps -a`)
5. `spurious-server start` (check status: `spurious-server status`)
6. `spurious init`
7. `spurious up` (check status: `spurious ports`)
8. `rake harness` (sets up SQS queue based on `config/{env}/env.yaml`)
9. `bundle exec rackup -s puma -p 9293`
10. `curl http://0.0.0.0:9293/` (or visit `http://localhost:9293/`)

> Note: now Boot2Docker and Spurious have all run, the other applications don't need them to be run.

### Renderer

1. `cd Renderer`
2. `bundle install`
3. `rake harness` (sets up S3 bucket based on `config/{env}/env.yaml`)
4. `bundle exec rackup -s puma -p 9294` (note: different port number)

> Note: technically the Renderer doesn't need the overhead of a web server (even one as low-level and lightweight as Rack) so the `bundle` command could well execute a Ruby script directly to instantiate the polling of the AWS SQS queue (TODO: fix that)

### Broker

...
