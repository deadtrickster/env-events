# Graceful Degradation with Prometheus

(based on [prometheus-compose](https://github.com/vegasbrianc/prometheus))

## Usage

By default high_load alert triggered when more than 400 messages queued.

- http://localhost:4000/put_messages/420 to put 420 messages.
- http://localhost:4000/messages/6300 to get 6300 messages.

Wait a little after putting more than 400 messages and it will reply with 503
if you try to put more

## License

MIT
