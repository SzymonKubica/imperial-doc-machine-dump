defmodule ProcessesTest do
  use ExUnit.Case
  doctest Processes

  test "greets the world" do
    assert Processes.hello() == :world
  end
end
