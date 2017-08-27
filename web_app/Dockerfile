FROM library/elixir
MAINTAINER Ilya Khaprov <i.khaprov@gmail.com>

ARG port=4000
EXPOSE $port
ENV PORT=$port

RUN mix local.hex --force \
    && mix local.rebar --force

COPY . .
ENTRYPOINT ["iex"]
