# TokenAuth

A Plug that provides Bearer authentication by checking the requests' token
matches the configured one.

## Installation

```elixir
{:token_auth, "~> 1.1"}
```

## Usage

Plug it in your router or pipeline:

```elixir
plug(TokenAuth)
```

Then in you config:

```elixir
config :token_auth,
  token: {:system, "AUTH_TOKEN", "token"},
  realm: {:system, "AUTH_REALM", "Authentication"}
```

It works with any env name:


```elixir
config :token_auth,
  token: {:system, "APP_TOKEN", "token"},
  realm: {:system, "APP_REALM", "Authentication"}
```
