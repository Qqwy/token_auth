# Token auth

A Plug that provides Bearer authentication by checking the requests' token
matches the configured one.

## Installation

```elixir
{:token_auth, "~> 1.0.0"}
```

## Usage

Plug it in your router or pipeline:

```elixir
plug TokenAuth, [token: "youtoken", realm: "Authentication"]
```

If you use Confex, you can add the options to your configuration:

```elixir
config :yourapp,
  token_auth: [
    username: {:system, "APP_TOKEN", nil},
    realm: "Authentication"
  ]
```

And your router, you would write:

```elixir
plug TokenAuth, Confex.get_env(:yourapp, :token_auth)
```
