# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :checking_account,
  ecto_repos: [CheckingAccount.Repo]

# Configures the endpoint
config :checking_account, CheckingAccountWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Hz7S1GnXZaVkF/4hYBjKXW85TcdLOvIE5PF0w0JH3tlsWl8ld5ZIs0eEXHZdmyqc",
  render_errors: [view: CheckingAccountWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: CheckingAccount.PubSub, adapter: Phoenix.PubSub.PG2]

config :checking_account, CheckingAccount.Guardian,
  issuer: "checking_account",
  secret_key: "gJ1Rh4Hqc6r6dycFZro4UeSyZgYFQ1UErPCJgveeXzySQWg6GOJReNWq2Ipft7cW"

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
