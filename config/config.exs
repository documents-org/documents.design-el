# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :documents_design,
  ecto_repos: [DocumentsDesign.Repo]

# Configures the endpoint
config :documents_design, DocumentsDesignWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "zqDQLrIegy7D6uDL3ta2EBqPcu9SZ66AuEc5Goh+Hcvc8yZmBLzEAOTm/wT00jNy",
  render_errors: [view: DocumentsDesignWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: DocumentsDesign.PubSub, adapter: Phoenix.PubSub.PG2]

config :documents_design, DocumentsDesign.Mailer,
  adapter: Bamboo.SMTPAdapter,
  server: System.get_env("SMTP_SERVER"),
  port: System.get_env("SMTP_PORT"),
  username: System.get_env("SMTP_USERNAME"),
  password: System.get_env("SMTP_PASSWORD")

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
