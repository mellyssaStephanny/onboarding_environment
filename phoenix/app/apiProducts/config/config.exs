# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :apiProducts,
  ecto_repos: [ApiProducts.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :apiProducts, ApiProductsWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "NC+oDZPmlu1UoJvvVRvE6hrWWqJ1cxASVdsvP6f1eYRqRzQw0wbH6xde3F9zRiAm",
  render_errors: [view: ApiProductsWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: ApiProducts.PubSub,
  live_view: [signing_salt: "dhmXJy4p"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
