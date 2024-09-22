defmodule ClentServerrTest do
  use ExUnit.Case
  doctest ClientServer

  test "greets the world" do
    assert ClientServer.hello() == :world
  end
end
