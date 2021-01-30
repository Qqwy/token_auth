defmodule TokenAuthTest do
  alias Plug.Conn

  use ExUnit.Case
  doctest TokenAuth

  import Dummy

  test "init/1" do
    assert TokenAuth.init(:options) == :options
  end

  test "send_401/1" do
    auth_header = "Bearer realm=\"\", error=\"invalid_token\""

    dummy Conn, [
      {"put_resp_header", fn _a, _b, _c -> :header end},
      {"put_resp_content_type", fn _a, _b -> :content_type end},
      {"send_resp", fn _a, _b, _c -> :resp end},
      {"halt", :halt}
    ] do
      assert TokenAuth.send_401(:conn) == :halt
      assert called(Conn.put_resp_header(:conn, "www-authenticate", auth_header))
      assert called(Conn.put_resp_content_type(:header, "text/plain"))
      assert called(Conn.send_resp(:content_type, 401, "401 Unauthorized"))
    end
  end

  test "is_excluded?/1" do
    dummy Application, [{"get_env/3", []}] do
      conn = %{private: %{plug_route: {"/"}}}
      result = TokenAuth.is_excluded?(conn)
      assert called(Application.get_env(:token_auth, :excluded, []))
      assert result == false
    end
  end

  test "is_excluded?/1 with an excluded path" do
    dummy Application, [{"get_env/3", ["/path"]}] do
      conn = %{private: %{plug_route: {"/path"}}}
      assert TokenAuth.is_excluded?(conn) == true
    end
  end

  test "call/2 with successful authentication" do
    dummy TokenAuth, [{"verify_auth", true}] do
      assert TokenAuth.call(:conn, :options) == :conn
      assert called(TokenAuth.verify_auth(:conn))
    end
  end

  test "call/2 with failing authentication" do
    dummy TokenAuth, [{"verify_auth", false}, {"send_401", 401}] do
      assert TokenAuth.call(:conn, :options) == 401
    end
  end
end
