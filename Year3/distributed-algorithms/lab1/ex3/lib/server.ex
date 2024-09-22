
# distributed algorithms, n.dulay, 3 jan 23
# simple client-server, v1

defmodule Server do

def start do
  IO.puts "-> Server at #{Helper.node_string()}"
  next()
end # start

defp next do
  receive do
  { :circle, client, radius } ->
    send client, { :result, 3.14159 * radius * radius }
  { :square, client, side } ->
    send client, { :result, side * side }
  { :triangle, client, a, b, c } ->
    s = 0.5 * (a + b + c)
    area = Helper.sqrt(s * (s - a) * (s - b) * (s - c))
    send client, { :result, area }
  end # receive
  next()
end # next

end # Server

