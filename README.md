# TokenAuth

A Plug that provides Bearer authentication by checking whether the request's authorization matches a value.

## Installation

```elixir
{:token_auth, "~> 1.1"}
```

## Usage

Plug it in your router or pipeline:

```elixir
plug(TokenAuth)
```

Then in you config set the token:

```elixir
config :token_auth,
  token: "TOKEN",
  realm: "Your app"
```

If you want to use an environment variable, you can use System.get_env:

```elixir
config :token_auth,
  token: System.get_env("YOURAPP_TOKEN"),
  realm: System.get_env("YOURAPP_NAME")
```

Try it out:

```sh
curl -X http://localhost:4000/protected -H "Authorization: Bearer TOKEN"
```
