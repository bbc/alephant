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

### Spurious

Spurious allows us to develop against locally running versions of specific AWS resources (such as S3, DynamoDB and SQS).

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

> Note: technically the Renderer doesn't need the overhead of a web server (even one as low-level and lightweight as Rack) so the `bundle` command could well execute a Ruby script directly to instantiate the polling of the AWS SQS queue (TODO: fix that)

### Broker

...
