
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

  bind(peers, 0, [1, 6])
  bind(peers, 1, [0, 2, 3])
  bind(peers, 2, [1, 3, 4])
  bind(peers, 3, [1, 2, 5])
  bind(peers, 4, [2])
  bind(peers, 5, [3])
  bind(peers, 6, [0, 7])
  bind(peers, 7, [6, 8, 9])
  bind(peers, 8, [7, 9])
  bind(peers, 9, [7, 8])

  send first(peers), {:hello}

end # start :cluster_start

defp bind(peers, peer_index, neighbours_indices) do
  neighbours = for i <- neighbours_indices do Enum.at(peers, i) end
  send Enum.at(peers, peer_index), {:neighbours, neighbours}
end

end # Flooding

