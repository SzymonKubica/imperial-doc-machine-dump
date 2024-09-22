defmodule Client do
  @deposit  1
  @transfer 2
  @withdraw 3
  def start(name) do
    client_name = name
    IO.puts "-> Client #{name} at #{NodeManager.node_string()}. "
    receive do
    {:bind, server, user} -> query_for_balance(server, client_name, user)
    end
  end

  defp query_for_balance(server, client_name, user) do
    IO.puts "-> Client #{client_name} at #{NodeManager.node_string()} sending a request to " <>
    "the server #{inspect(server)}\n to inspect account balance for user: #{user}"
    send server, {:get_balance, self(), user}
    receive do
    {:account_balance, server, user, amount} ->
      IO.puts "Received account balance for user: #{user}. Balance: #{amount}"
      perform_transaction(server, client_name, user, amount)
    end
  end

  defp perform_transaction(server, client_name, user, amount) do
    IO.puts "-> Client at #{NodeManager.node_string()} sending a request to " <>
    "the server #{inspect(server)}\n to perform a transaction for user: #{user}"
    choice = Enum.random 1..3
    transaction_amount = Enum.random 1..amount
    case choice do
      @deposit  -> send server, {:deposit, inspect(self()), transaction_amount}
      @transfer -> send server, {:transfer, inspect(self()), transaction_amount}
      @withdraw -> send server, {:withdraw, inspect(self()), transaction_amount}
    end
    Process.sleep(Enum.random 2000..5000)
    query_for_balance(server, client_name, user)
  end
end
