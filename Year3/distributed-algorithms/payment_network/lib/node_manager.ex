defmodule NodeManager do
  def node_ip_addr do
    {:ok, interfaces} = :inet.getif() # Gets the interfaces
    {address, _gateway, _mask} = hd(interfaces) # Inspect the data for the first interface
    {a, b, c, d} = address
    "#{a}.#{b}.#{c}.#{d}"
  end

  def node_string(), do: "#{node()} (#{node_ip_addr()})"

  def node_exit do
    IO.puts "Exiting #{node()}"
    System.stop(0) # Stops and exits the node.
  end

  def exit_after(time) do
    Process.sleep(time)
    node_exit()
  end
  def node_init do
    config = Map.new
    config = Map.put config, :max_time, String.to_integer(Enum.at(System.argv, 0))
    config = Map.put config, :node_suffix, Enum.at(System.argv, 1)
    config = Map.put config, :operation_mode, :'#{Enum.at(System.argv, 2)}'
    spawn(NodeManager, :exit_after, [config.max_time])
    config
  end
end
