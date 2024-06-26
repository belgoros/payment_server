# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :payment_server,
  ecto_repos: [PaymentServer.Repo]

# Configures the endpoint
config :payment_server, PaymentServerWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    formats: [json: PaymentServerWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: PaymentServer.PubSub,
  live_view: [signing_salt: "F7h7DHLn"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Alpha Vantage settings
config :payment_server,
  exchange_server_api_url: "http://localhost:4001/query",
  exchange_server_options: [
    apikey: "demo",
    function: "CURRENCY_EXCHANGE_RATE"
  ],
  accepted_currencies: [:EUR, :USD, :CAD, :GBP]

# ecto_shorts settings
config :ecto_shorts,
  repo: PaymentServer.Repo,
  error_module: EctoShorts.Actions.Error

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
