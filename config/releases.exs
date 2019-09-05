import Config

config :echo_server, EchoServerWeb.Endpoint,
  server: true,
  url: [host: System.get_env("APP_NAME") <> ".gigalixirapp.com", port: 443]
