use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :echo_server, EchoServerWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

config :echo_server, EchoServer.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "echo_server_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
