
# distributed algorithms, n.dulay, 3 jan 23
# basic flooding, v1

defmodule Peer do
  @message_timeout 1000

  def start(my_index) do
    log(:startup)
    receive do
      {:neighbours, peers} ->
        log(:receive_neighbours, peers)
        messages_received = 0
        next(my_index, peers, messages_received)
    end
  end

  def next(my_index, peers, messages_received) do
    Process.sleep(Enum.random(1000..3000)) # Simulate a delay in response taking a while.
    receive do
      {:hello} ->
      log(:receive_hello, my_index)
      message_peers(peers)
      next(my_index, peers, messages_received + 1)
    after
      @message_timeout -> log(:log_received_total, messages_received)
      next(my_index, peers, messages_received)
    end
  end

  defp message_peers(peers) do
      for peer <- peers do
        send peer, {:hello}
      end
  end

  defp log(message_type, args \\ nil) do
    message = case {message_type, args} do
      {:startup, nil} ->
        "-> Peer at #{Helper.node_string()} starting up..."
      {:receive_neighbours, peers} ->
        "-> Peer at #{Helper.node_string_short()} received its neighbours:\n" <>
        "[ #{Enum.map(peers, fn peer -> "#{inspect peer} " end)}]"
      {:receive_hello, my_index} ->
        "-> #{get_id(my_index)} at #{Helper.node_string_short()} was just " <>
        "greeted with hello."
      {:log_received_total, messages_received} ->
        "-> Peer at #{Helper.node_string_short()} received a total of " <>
        "#{messages_received} messages."
    end
    IO.puts message
  end

  defp get_id(my_index),  do: "Peer #{my_index} (#{inspect self()})"

end # Peer

