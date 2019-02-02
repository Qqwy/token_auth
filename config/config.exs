use Mix.Config

config :token_auth,
  token: {:system, "AUTH_TOKEN", "token"},
  realm: {:system, "AUTH_REALM", "Authentication"}
