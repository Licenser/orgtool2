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
    #          1      2        4      8        16       32       64
    default:  [:active],
    user:     [:read, :create, :edit, :delete],
    player:   [:read, :create, :edit, :delete],
    unit:     [:read, :create, :edit, :delete, :assign, :accept, :apply],
    category: [:read, :create, :edit, :delete],
    template: [:read, :create, :edit, :delete],
    item:     [:read, :create, :edit, :delete],
    reward:   [:read, :create, :edit, :delete]
  }


config :guardian_db, GuardianDb,
  repo: OrgtoolDb.Repo,
  # in minutes
  sweep_interval: 60


config :ueberauth, Ueberauth,
  providers: [
    identity: {Ueberauth.Strategy.Identity, [callback_methods: ["POST"]]},
    google: {Ueberauth.Strategy.Google, []},
    twitter: {Ueberauth.Strategy.Twitter, []},
    slack: {Ueberauth.Strategy.Slack, []},
    facebook: {Ueberauth.Strategy.Facebook, []},
    github: {Ueberauth.Strategy.Github, []},
    microsoft: {Ueberauth.Strategy.Microsoft, []},
    discord: {Ueberauth.Strategy.Discord, []},
    wordpress: {Ueberauth.Strategy.Wordpress, []},
  ]

config :ueberauth, Ueberauth.Strategy.Google.OAuth,
  client_id: System.get_env("GOOGLE_CLIENT_ID"),
  client_secret: System.get_env("GOOGLE_CLIENT_SECRET")

config :ueberauth, Ueberauth.Strategy.Twitter.OAuth,
  consumer_key: System.get_env("TWITTER_CLIENT_ID"),
  consumer_secret: System.get_env("TWITTER_CLIENT_SECRET")

config :ueberauth, Ueberauth.Strategy.Slack.OAuth,
  client_id: System.get_env("SLACK_CLIENT_ID"),
  client_secret: System.get_env("SLACK_CLIENT_SECRET")

config :ueberauth, Ueberauth.Strategy.Facebook.OAuth,
  client_id: System.get_env("FACEBOOK_CLIENT_ID"),
  client_secret: System.get_env("FACEBOOK_CLIENT_SECRET")

config :ueberauth, Ueberauth.Strategy.Github.OAuth,
  client_id: System.get_env("GITHUB_CLIENT_ID"),
  client_secret: System.get_env("GITHUB_CLIENT_SECRET")

config :ueberauth, Ueberauth.Strategy.Microsoft.OAuth,
  client_id: System.get_env("MICROSOFT_CLIENT_ID"),
  client_secret: System.get_env("MICROSOFT_CLIENT_SECRET")

config :ueberauth, Ueberauth.Strategy.Discord.OAuth,
  client_id: System.get_env("DISCORD_CLIENT_ID"),
  client_secret: System.get_env("DISCORD_CLIENT_SECRET")

config :ueberauth, Ueberauth.Strategy.Wordpress.OAuth,
  client_id: System.get_env("WORDPRESS_CLIENT_ID"),
  client_secret: System.get_env("WORDPRESS_CLIENT_SECRET"),
  host: System.get_env("WORDPRESS_HOST")



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

