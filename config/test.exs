import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
# System.get_env("GOOGLE_RECAPTCHA_API_URL")
config :ushorten, Ushorten.Repo,
  username: System.get_env("DB_TEST_USERNAME"),
  password: System.get_env("DB_TEST_PASSWORD"),
  hostname: System.get_env("DB_TEST_HOSTNAME"),
  database: "#{System.get_env("DB_TEST_DATABASE")}#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :ushorten, UshortenWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "fUML3jeKEU8NCso/Utn84tBZqB0nhRPgyuyZXSwenWgHAgvN99B+scfqweDiEsAO",
  server: false

# In test we don't send emails.
config :ushorten, Ushorten.Mailer, adapter: Swoosh.Adapters.Test

config :ushorten, :google_client, GoogleClientMock

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
