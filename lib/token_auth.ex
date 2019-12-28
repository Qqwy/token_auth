defmodule TokenAuth do
  alias Plug.Crypto
  alias Plug.Conn

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
  Creates the comparison token
  """
  defp get_token() do
    "Bearer " <> Confex.get_env(:token_auth, :token)
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
  def unauthorised(conn) do
    realm = Confex.get_env(:token_auth, :realm)

    conn
    |> Conn.put_resp_header(
      "www-authenticate",
      "Basic realm=\"#{realm}\", error=\"invalid_token\""
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
      if tokens_match(authorization, get_token()) do
        true
      end
    end
  end

  def call(conn, _options) do
    if TokenAuth.verify_auth(conn) do
      conn
    else
      TokenAuth.unauthorised(conn)
    end
  end
end
