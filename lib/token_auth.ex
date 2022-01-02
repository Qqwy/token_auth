defmodule TokenAuth do
  @behaviour Plug
  alias Plug.Crypto
  alias Plug.Conn

  @realm Application.get_env(:token_auth, :realm)
  @token Application.get_env(:token_auth, :token)

  def init(options) do
    options
  end

  @doc """
  Extracts an header when present, or return nil
  """
  defp extract_header(header) do
    if Enum.count(header) > 0 do
      Enum.at(header, 0)
    end
  end

  @doc """
  Get the authorization header value
  """
  defp authorization_header(conn) do
    conn
    |> Conn.get_req_header("authorization")
    |> extract_header()
  end

  @doc """
  Finds out whether auth and token match
  """
  defp tokens_match(authorization, token) do
    if Crypto.secure_compare(authorization, token) do
      true
    end
  end

  @doc """
  Produces a 401 response
  """
  def send_401(conn) do
    conn
    |> Conn.put_resp_header(
      "www-authenticate",
      "Bearer realm=\"#{@realm}\", error=\"invalid_token\""
    )
    |> Conn.put_resp_content_type("text/plain")
    |> Conn.send_resp(401, "401 Unauthorized")
    |> Conn.halt()
  end

  @doc """
  Verifies the auth header is correct
  """
  def verify_auth(conn) do
    authorization = authorization_header(conn)

    if authorization do
      if tokens_match(authorization, "Bearer #{@token}") do
        true
      end
    end
  end

  @doc """
  Whether the path is excluded.
  """
  def is_excluded?(conn) do
    :token_auth
    |> Application.get_env(:excluded, [])
    |> Enum.member?(conn.request_path)
  end

  def unauthorised(conn) do
    if TokenAuth.is_excluded?(conn) do
      conn
    else
      TokenAuth.send_401(conn)
    end
  end

  def call(conn, _options) do
    case TokenAuth.verify_auth(conn) do
      true -> conn
      _ -> TokenAuth.unauthorised(conn)
    end
  end
end
