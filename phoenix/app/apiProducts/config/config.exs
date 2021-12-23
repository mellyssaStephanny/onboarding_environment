# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :apiProducts,
  ecto_repos: [ApiProducts.Repo]
  
# Configures the endpoint
config :apiProducts, ApiProductsWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "SkiDA6haznhdc2g3ZNTQQL4Pmi/e79rNqG8iLl++5Pz2Z2jtD+S8wSy1crCVwbCE",
  render_errors: [view: ApiProductsWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: ApiProducts.PubSub,
  live_view: [signing_salt: "N4DWfGuT"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# redis connection
config :exredis,
  host: "127.0.0.1",
  port: 6379,
  password: "",
  db: 0,
  reconnect: :no_reconnect,
  max_queue: :infinity

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
