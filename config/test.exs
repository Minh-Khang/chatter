use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :chatter, ChatterWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :chatter, Chatter.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "chatter_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# Configure Argon for speed up tests
config :argon2_elixir,
  t_cost: 1,
  m_cost: 8
