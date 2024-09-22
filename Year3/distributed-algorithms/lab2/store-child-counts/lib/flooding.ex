
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

  for i <- 1..config.n_peers do
     bind(peers, i - 1, [rem(i, 10)])
  end


  send first(peers), {:hello, {"Flooding (#{inspect self()})", self()}}

end # start :cluster_start


defp bind(peers, peer_index, neighbours_indices) do
  neighbours = for i <- neighbours_indices do Enum.at(peers, i) end
  send Enum.at(peers, peer_index), {:neighbours, neighbours}
end

end # Flooding

