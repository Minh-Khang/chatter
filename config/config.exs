# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :chatter,
  ecto_repos: [Chatter.Repo]

# Configures the endpoint
config :chatter, ChatterWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "iVrf4I3PmOSD3/+JQ0OQMMXi2oJT6WTCu/havyPqg0ljeAYdnc8LM8ht+tZ5wl7g",
  render_errors: [view: ChatterWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Chatter.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

config :chatter, Chatter.Accounts.Guardian,
  issuer: "chatter",
  secret_key: "f2pNvTX34brCmO5QuGyW7mz2yt/WtwHx1itNuoQI1q/A7ireuoAZxGABgpFdgjcn" # put the result of the mix command above here

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
