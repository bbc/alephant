# Request-Based Alephant Example Application

This example is based upon two components (below) and is a closed loop synchronous system.

1. Broker (using [alephant-broker](https://github.com/BBC-News/alephant-broker)).
2. Renderer (using [alephant-publisher-request](https://github.com/BBC-News/alephant-publisher-request)).

### Broker

The Broker's role is to accept requests from a client (`curl` or web browser) and route that request onto the relevant Renderer which will return content, which can then in-turn be returned to the client. The Broker determines which Renderer to use by looking up it's URL in a DynamoDB table using a hash of the routing params found in the client's query parameters. E.g:

Client URL:
```
http://localhost:9292/component/test_component?routing[lang]=en-gb
```
Routing Params:
```
{
  :lang => 'en-gb'
}
```
Hash of Routing Params:
```
2a8f184f85d2c22efd6c4fdeb215f881
```

### Renderer

Upon receiving a request the Renderer will hit a pre-specified endpoint (depending on requested component) and render a HTML template using the returned JSON, and then return the rendered HTML to the Broker.

## Setup

Each component is a rack application so needs to be started independently. As the Broker relies upon querying a DynamoDB table, you will need to setup either [Spurious](https://github.com/stevenjack/spurious) or a standard AWS account. There is a detailed tutorial on how to setup both in this [README](https://github.com/BBC-News/alephant/tree/master/Example/Event-based#running-each-application).

#### Broker

```
cd Broker
```
```
bundle install
```
```
rake harness
```
```
APP_ENV=development bundle exec rackup config.ru -p 9292
```

#### Renderer

```
cd Renderer
```
```
bundle install
```
```
APP_ENV=development bundle exec rackup config.ru -p 9393
```

## Usage

- Open a web browser.
- Go to `http://localhost:9292/component/test_component`

You should see a webpage displaying the current time/date.
