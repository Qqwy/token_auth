defmodule TokenAuthTest do
  use ExUnit.Case
  doctest TokenAuth

  import Dummy

  test "init/1" do
    assert TokenAuth.init(:options) == :options
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
