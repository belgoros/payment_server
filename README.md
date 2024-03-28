# PaymentServer

## Goals

We want to be able to send and receive money between diﬀerent users and diﬀerent currencies, and have a live exchange rate.
This should be accessible over GraphQL mutations and queries and should have subscriptions for exchange rates and current total worth of a user.

## Exchange Rate Monitor

In order to send currencies and assess a users total worth, we'll need to setup something to track and monitor the exchange rate,
so that we can ensure that everyone is getting the latest rate. We'll use some sort of OTP process to encapsulate this functionality and have it allow us
to find current exchange rates for our transactions and user stats.

AlphaVantage exchange server API https://www.alphavantage.co/documentation/#currency-exchange

## AlphaVantage Server

Because of the rather limited api limits, you can use the provided binary to run a server at http://localhost:4001.
The documentation from AlphaVantage still applies however the exchange rate is updated every second and the rate is unlimited.
To start this server, simply extract the provided `alpha-vantage.tar.gz` and run `tar -xzf alpha-vantage.tar.gz` to extract
the zip file, then run `./alpha_vantage/bin/default start`. You can then use the server at `http://localhost:4001`.
You're also able to choose a custom port by setting PORT environment variable before starting the server
`env PORT=4500 ./alpha_vantage/bin/default start`
In order to run the server, the elixir versions must match up.

## Dockerhub Version

To make it easier to get setup, we also have a DockerHub image with the server so you can just pull it in and go. Once you have
docker installed you can run `docker pull mikaak/alpha-vantage:latest` to pull in the image, and then start it with
`docker run -p 4001:4000 -it mikaak/alpha-vantage:latest` and you will now have the server running on port 4001

## Implemented features

### OTP server

- track and monitor the exchange rate

### GraphQL queries

- fetch users
- fetch wallets
- fetch a wallet by currency
- total worth of all the user's wallets in a single currency

### Mutations

- create a user
- create a wallet
- send money

### Subscriptions

- Total Worth Change by Specific User
- Exchange Rate Updated for Specific Currency
- Exchange Rate Updated for all Currencies

## To start your Phoenix server:

- Run `mix setup` to install and setup dependencies
- Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

- Official website: https://www.phoenixframework.org/
- Guides: https://hexdocs.pm/phoenix/overview.html
- Docs: https://hexdocs.pm/phoenix
- Forum: https://elixirforum.com/c/phoenix-forum
- Source: https://github.com/phoenixframework/phoenix
