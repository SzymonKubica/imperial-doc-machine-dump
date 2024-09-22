defmodule PaymentNetwork do
  @user "Szymon"
  def start do
    config = NodeManager.node_init()
    start(config.operation_mode, config)
  end

  defp start(:basic_mode, config) do
    IO.puts "-> PaymentNetwork running at #{NodeManager.node_string()}"
    server = Node.spawn(:'payment_network_#{config.node_suffix}', TreasuryServer, :start, [])
    clients = for i <- 1..5, i < 3 do
      Node.spawn(:'payment_network_#{config.node_suffix}', Client, :start, ["#{i}"])
    end

    for client <- clients do
      send client, {:bind, server, @user}
    end
  end
end
