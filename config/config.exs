# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :joust,
  ecto_repos: [Joust.Repo]

# Configures the endpoint
config :joust, Joust.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "2O2YS5bbK2HrdU/zTMu/auml3a2z1tKgFERZdil868G+oJMp/+HeW0M1X0JcjjrC",
  render_errors: [view: Joust.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Joust.PubSub,
           adapter: Phoenix.PubSub.PG2]

config :phoenix_guardian, ecto_repos: [Joust.Repo]
# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :guardian, Guardian,
  issuer: "Joust.#{Mix.env}",
  serializer: Joust.GuardianSerializer,
  ttl: { 30, :days },
  verify_issuer: true,
  secret_key: to_string(Mix.env),
  hooks: GuardianDb,
  permissions: %{
    default: [
      :read_profile,
      :write_profile,
      :read_token,
      :revoke_token
    ]
  }

  config :ueberauth, Ueberauth,
    providers: [
      github: {Ueberauth.Strategy.Github, [uid_field: "login"]},
      slack: { Ueberauth.Strategy.Slack, [default_scope: "users:read,identify"]},
      google: {Ueberauth.Strategy.Google, []},
      facebook: {Ueberauth.Strategy.Facebook, [profile_fields: "email, name"]},
      identity: {Ueberauth.Strategy.Identity, [callback_methods: ["POST"]]},
    ]

  config :ueberauth, Ueberauth.Strategy.Github.OAuth,
    client_id: System.get_env("GITHUB_CLIENT_ID"),
    client_secret: System.get_env("GITHUB_CLIENT_SECRET")

  config :ueberauth, Ueberauth.Strategy.Slack.OAuth,
    client_id: System.get_env("SLACK_CLIENT_ID"),
    client_secret: System.get_env("SLACK_CLIENT_SECRET")

  config :ueberauth, Ueberauth.Strategy.Google.OAuth,
    client_id: System.get_env("GOOGLE_CLIENT_ID"),
    client_secret: System.get_env("GOOGLE_CLIENT_SECRET")

    # Optional add redirect_uri
    # redirect_uri: "http://lvh.me:4000/auth/google/callback"

  config :ueberauth, Ueberauth.Strategy.Facebook.OAuth,
    client_id: System.get_env("FACEBOOK_CLIENT_ID"),
    client_secret: System.get_env("FACEBOOK_CLIENT_SECRET")

    # Optional add redirect_uri
    # redirect_uri: "http://lvh.me:4000/auth/facebook/callback"

  config :guardian_db, GuardianDb,
    repo: Joust.Repo,
    sweep_interval: 60 # 60 minutes

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
