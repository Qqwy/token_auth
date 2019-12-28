defmodule TokenAuthTest do
  alias Plug.Conn

  use ExUnit.Case
  doctest TokenAuth

  import Dummy

  test "init/1" do
    assert TokenAuth.init(:options) == :options
  end

  test "unauthorised/1" do
    auth_header = "Bearer realm=\"\", error=\"invalid_token\""

    dummy Conn, [
      {"put_resp_header", fn _a, _b, _c -> :header end},
      {"put_resp_content_type", fn _a, _b -> :content_type end},
      {"send_resp", fn _a, _b, _c -> :resp end},
      {"halt", :halt}
    ] do
      assert TokenAuth.unauthorised(:conn) == :halt
      assert called(Conn.put_resp_header(:conn, "www-authenticate", auth_header))
      assert called(Conn.put_resp_content_type(:header, "text/plain"))
      assert called(Conn.send_resp(:content_type, 401, "401 Unauthorized"))
    end
  end

  test "call/2 with successful authentication" do
    dummy TokenAuth, [{"verify_auth", true}] do
      assert TokenAuth.call(:conn, :options) == :conn
      assert called(TokenAuth.verify_auth(:conn))
    end
  end

  test "call/2 with failing authentication" do
    dummy TokenAuth, [{"verify_auth", false}, {"unauthorised", :unauthorised}] do
      assert TokenAuth.call(:conn, :options) == :unauthorised
    end
  end
end
