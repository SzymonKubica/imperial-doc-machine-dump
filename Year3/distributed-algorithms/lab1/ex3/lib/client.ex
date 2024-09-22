
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
  selection = Helper.random(3)
  cond do
    selection == 1 -> send server, { :circle, self(), 1.0 }
    selection == 2 -> send server, { :square, self(), 2.0 }
    selection == 3 -> send server, { :triangle, self(), 2.0, 3.0, 4.0 }
  end
  receive do { :result, area } -> IO.puts "Area is #{area}" end
  Process.sleep(Helper.random(3000))
  next(server)
end # next

end # Client

