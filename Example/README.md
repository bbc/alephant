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

You'll need to start each application in the order they appear below (so start Sender first, then the Renderer and finally the Broker).

If Boot2Docker and Spurious are already running then you can skip those steps.

### Sender

1. `cd Sender`
2. `bundle install`
3. `boot2docker init`
4. `boot2docker up` (check status: `boot2docker status` and `docker ps -a`)
5. `spurious-server start` (check status: `spurious-server status`)
6. `spurious init`
7. `spurious up` (check status: `spurious ports`)
8. `rake harness`
9. `bundle exec rackup -s puma -p 9293`
10. `curl http://0.0.0.0:9293/` (or visit `http://localhost:9293/`)

### Renderer

...

### Broker

...
