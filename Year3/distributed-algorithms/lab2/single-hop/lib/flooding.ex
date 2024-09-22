
# distributed algorithms, n.dulay, 3 jan 23
# basic flooding, v1

# flood message through 1-hop (fully connected) network

import List

defmodule Flooding do

def start do
  config = Helper.node_init()
  start(config.start_function, config)
end # start

defp start(:cluster_wait, _) do
  :skip
end # start :cluster_wait

defp start(:cluster_start, config) do
  IO.puts "-> Flooding at #{Helper.node_string()}"

  peers = for i <- 1..config.n_peers do
    Node.spawn(:'peer#{i - 1}_#{config.node_suffix}', Peer, :start, [i])
  end

  for peer <- peers do
    send peer, {:neighbours, generate_random_neighbours(peers, config)}
  end

  send first(peers), {:hello}

end # start :cluster_start

defp generate_random_neighbours(peers, config), do: Enum.take_random(peers, Enum.random(0..config.n_peers-1))

end # Flooding

