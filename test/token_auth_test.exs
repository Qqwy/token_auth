defmodule TokenAuthTest do
  use ExUnit.Case
  doctest TokenAuth

  test "init/1" do
    assert TokenAuth.init(:options) == :options
  end
end
