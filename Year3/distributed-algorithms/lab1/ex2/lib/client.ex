
# distributed algorithms, n.dulay, 3 jan 23
# simple client-server, v1

defmodule Client do

def start do
  IO.puts "-> Client at #{Helper.node_string()}"
  receive do
  { :bind, server } -> next(server)
  end # receive
end # start

defp next(server) do
  send server, { :circle, 1.0 }
  receive do { :result, area } -> IO.puts "Area is #{area}" end
  Process.sleep(1000)
  next(server)
end # next

end # Client

