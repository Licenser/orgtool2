# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :orgtool_db,
  ecto_repos: [OrgtoolDb.Repo]

# Configures the endpoint
config :orgtool_db, OrgtoolDb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "8GbFmmOV21S7tyn+zAyq1ZyLoHDcsgTjy5tNc6xQMJvlB6iuQfubHmRlqhWkaLk7",
  render_errors: [view: OrgtoolDb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: OrgtoolDb.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :guardian, Guardian,
  issuer: "OrgtoolDb.#{Mix.env}",
  ttl: {30, :days},
  verify_issuer: true,
  serializer: OrgtoolDb.GuardianSerializer,
  secret_key: to_string(Mix.env),
  hooks: GuardianDb,
  permissions: %{
    default: [
      :read_profile,
      :write_profile,
      :read_token,
      :revoke_token,
    ],
  }

config :guardian_db, GuardianDb,
  repo: OrgtoolDb.Repo,
  # in minutes
  sweep_interval: 60,
  permissions: %{
    default: [:read, :write],
    admin: [:dashboard, :reconcile]
  }


config :ueberauth, Ueberauth,
  providers: [
    google: {Ueberauth.Strategy.Google, []},
    identity: {Ueberauth.Strategy.Identity, [callback_methods: ["POST"]]},
  ]

config :ueberauth, Ueberauth.Strategy.Google.OAuth,
  client_id: System.get_env("GOOGLE_CLIENT_ID"),
  client_secret: System.get_env("GOOGLE_CLIENT_SECRET")

config :phoenix, :format_encoders,
  "json-api": Poison

config :mime, :types, %{
  "application/vnd.api+json" => ["json-api"]
}

config :ja_serializer,
  pluralize_types: true

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

