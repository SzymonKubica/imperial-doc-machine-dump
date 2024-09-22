
# distributed algorithms, n.dulay, 3 jan 23
# simple client-server, v1

defmodule ClientServer do

def start do
  config = Helper.node_init()
  start(config.start_function, config)
end # start

defp start(:single_start, config) do
  IO.puts "-> ClientServer at #{Helper.node_string()}"
  server = Node.spawn(:'clientserver_#{config.node_suffix}', Server, :start, [])
  :timer.sleep(100)
  for _ <- 1..config.clients do
    client = Node.spawn(:'clientserver_#{config.node_suffix}', Client, :start, [])
    send client, { :bind, server }
  end
end # start :single_start

defp start(:cluster_wait, _) do
  :skip
end # start :cluster_wait

defp start(:cluster_start, config) do
  IO.puts "-> ClientServer at #{Helper.node_string()}"
  server = Node.spawn(:'server_#{config.node_suffix}', Server, :start, [])
  :timer.sleep(100)
  for i <- 1..config.clients do
  client = Node.spawn(:'client#{i}_#{config.node_suffix}', Client, :start, [])
    send client, { :bind, server }
  end
end # start :cluster_start

end # ClientServer

