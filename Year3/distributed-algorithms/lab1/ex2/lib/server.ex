
# distributed algorithms, n.dulay, 3 jan 23
# simple client-server, v1

defmodule Server do
 
def start do 
  IO.puts "-> Server at #{Helper.node_string()}"
  receive do
  { :bind, client } -> next(client) 
  end # receive
end # start
 
defp next(client) do
  receive do
  { :circle, radius } -> 
    send client, { :result, 3.14159 * radius * radius }
  { :square, side } -> 
    send client, { :result, side * side }
  end # receive
  next(client)
end # next

end # Server

