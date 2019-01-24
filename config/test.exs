use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :documents_design, DocumentsDesignWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :documents_design, DocumentsDesign.Repo,
  username: "postgres",
  password: "postgres",
  database: "documents_design_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
