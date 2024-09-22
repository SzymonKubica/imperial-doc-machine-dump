
# distributed algorithms, n.dulay, 3 jan 23
# -- time how long it takes to spawn n processes and
#    receive n :ok reply messages - one from each spawned process

defmodule Processes do

def start do
  create(100_000)
end # start

defp create(n) do
  parent = self()		# get our process id
  start  = Time.utc_now()	# get current time

  for _ <- 1..n do spawn(Processes, :send_msg, [parent]) end
  for _ <- 1..n do receive_reply() end

  finish   = Time.utc_now()
  duration = Time.diff(finish, start, :millisecond)

  IO.puts "Processes     = #{n}"
  IO.puts "Max processes = #{:erlang.system_info(:process_limit)}"
  IO.puts "Total time    = #{duration} milliseconds"
  IO.puts "Process time  = #{duration * 1000 /n} microseconds"
end # create

def send_msg(parent) do
  send parent, :ok
end # send_message

defp receive_reply() do
  receive do
    :ok -> :ok
  end # receive
end # receive_reply

end # Processes

