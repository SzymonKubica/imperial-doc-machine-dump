
# distributed algorithms, n.dulay, 3 jan 23
# basic flooding, v1

defmodule Peer do
  @message_timeout 1000

  def start(my_index) do
    log(:startup, my_index)
    receive do
      {:neighbours, peers} ->
        log(:receive_neighbours, {my_index, peers})
        messages_received = 0
        next(my_index, peers, messages_received)
    end
  end

  def get_random_sensor_reading(), do: Enum.random(0..100)

  def next(my_index, parent \\ nil, children \\ 0, peers, messages_received) do
    receive do
      {:hello, {sender_id_string, sender_pid} = sender} ->
      message_peers(my_index, peers)
      if parent == nil do
        log(:receive_hello_first_time, {my_index, sender, children})
        send sender_pid, {:child}
        next(my_index, sender, children, peers, messages_received + 1)
      else
        log(:receive_hello, {my_index, parent, children, sender_id_string})
        sensor_reading = get_random_sensor_reading()
        log(:sensor_reading, {my_index, parent, children, sensor_reading})
        sum = if children == 0 do
          sensor_reading
        else
          readings = for _ <- 1..children do
            receive do
              {:sum, sum} -> sum
            end
          end
          Enum.sum(readings) + sensor_reading
        end

        log(:log_sending_sum, {my_index, parent, children, sum})
        case parent do
          {_parent_id_str, parent_pid} ->
          send parent_pid, {:sum, sum}
        end
        next(my_index, parent, children, peers, messages_received + 1)
      end
      {:child} ->
        next(my_index, parent, children + 1, peers, messages_received + 1)
    after
      @message_timeout -> log(:log_received_total, {my_index, parent, children, messages_received})
      next(my_index, parent, children, peers, messages_received)
    end

 end

  defp message_peers(my_index, peers) do
      Process.sleep(250) # Simulate a delay in response taking a while.
      for peer <- peers do
        send peer, {:hello, {get_id(my_index), self()}}
      end
  end

  defp log(message_type, args) do
    message = case {message_type, args} do
      {:startup, my_index} ->
        "#{get_id(my_index)} at #{Helper.node_string()} starting up..."
      {:receive_neighbours, {my_index, peers}} ->
        "#{get_id(my_index)} at #{Helper.node_string_short()}\n" <>
        "  ->  Neighbours received:\n  ->  [ #{Enum.map(peers, fn peer -> "#{inspect peer} " end)}]"
      {:receive_hello_first_time, {my_index, {parent_str, _parent_pid}, children}} ->
        get_id_line(my_index, parent_str, children) <> "  ->  First greeting received from #{parent_str}."
      {:receive_hello, {my_index, {parent_str, _parent_pid}, children, sender}} ->
        get_id_line(my_index, parent_str, children) <> "  ->  Greeting received from #{sender}."
      {:log_received_total, {my_index, parent , children, messages_received}} ->
        case parent do
          {parent_str, _parent_pid} -> get_id_line(my_index, parent_str, children)
          nil -> get_id_line(my_index, "*No parent yet*", children)
        end <> "  ->  Total messages received: #{messages_received}."
      {:log_sending_sum, {my_index, {parent_str, _parent_pid}, children, sum}} ->
        get_id_line(my_index, parent_str, children) <> "  ->  Sending sum: #{sum} to the parent."
      {:sensor_reading, {my_index, {parent_str, _parent_pid}, children, value}} ->
        get_id_line(my_index, parent_str, children) <> "  ->  Sensor returned value: #{value}"
    end
    IO.puts message
  end

  defp get_id_line(my_index, parent, children), do: "#{get_id(my_index)} at #{Helper.node_string_short()} Parent: #{parent} Children = #{children}:\n"

  defp get_id(my_index),  do: "Peer #{my_index} (#{inspect self()})"

end # Peer

