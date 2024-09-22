defmodule TreasuryServer do
  def start do
    IO.puts "-> TreasuryServer running at #{NodeManager.node_string()}"
    process_request()
  end

  def process_request do
    receive do
    {:get_balance, client, user} ->
      IO.puts "Inspecting the account balance for user: #{user}"
      send client, {:account_balance, self(), user, 200}
    {:deposit, client, amount} -> IO.puts "Client #{client} tried to deposit #{amount}."
    {:transfer, client, amount} -> IO.puts "Client #{client} tried to transfer #{amount}."
    {:withdraw, client, amount} -> IO.puts "Client #{client} tried to withdraw #{amount}."
    end
    process_request()
  end
end
