# TokenAuth

A Plug that provides Bearer authentication by checking the requests' token
matches the configured one.

## Installation

```elixir
{:token_auth, "~> 1.0.0"}
```

## Usage

Plug it in your router or pipeline:

```elixir
plug TokenAuth, [token: "your_token", realm: "Authentication"]
```

If you use Confex, you can add the options to your configuration:

```elixir
config :yourapp,
  token_auth: [
    token: {:system, "APP_TOKEN", "token"},
    realm: "Authentication"
  ]
```

Then in your router, you would write:

```elixir
plug TokenAuth, Confex.get_env(:yourapp, :token_auth)
```