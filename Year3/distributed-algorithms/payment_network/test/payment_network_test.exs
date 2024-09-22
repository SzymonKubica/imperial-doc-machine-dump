defmodule PaymentNetworkTest do
  use ExUnit.Case
  doctest PaymentNetwork

  test "greets the world" do
    assert PaymentNetwork.hello() == :world
  end
end
