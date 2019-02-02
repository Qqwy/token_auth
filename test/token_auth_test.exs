defmodule TokenAuthTest do
  use ExUnit.Case
  doctest TokenAuth

  test "greets the world" do
    assert TokenAuth.hello() == :world
  end
end
