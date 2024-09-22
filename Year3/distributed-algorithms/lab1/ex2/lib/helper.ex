
# distributed algorithms, n.dulay, 3 jan 23
# various helper functions

defmodule Helper do

def lookup(name) do 
  addresses = :inet_res.lookup(name,:in,:a) 
  {a, b, c, d} = hd(addresses)  		# get octets for 1st ipv4 address
  :"#{a}.#{b}.#{c}.#{d}"
end # lookup

def node_ip_addr do
  {:ok, interfaces} = :inet.getif()		# get interfaces
  {address, _gateway, _mask}  = hd(interfaces)	# get data for 1st interface
  {a, b, c, d} = address   			# get octets for address
  "#{a}.#{b}.#{c}.#{d}"
end # node_ip_addr

def node_string(),   do: "#{node()} (#{node_ip_addr()})"

def pid_string(pid), do: inspect pid 		# to print a process id
def self_string(),   do: inspect self()

def random(n),       do: Enum.random 1..n
def sqrt(x),         do: :math.sqrt x

# --------------------------------------------------------------------------

def node_exit do 	# nicely stop and exit the node
  System.stop(0)	# System.halt(1) for a hard non-tidy node exit
end # node_exit

def exit_after(duration) do
  Process.sleep(duration)
  IO.puts "Exiting #{node()}"
  node_exit()	
end # exit_after

def node_init do  # get node arguments & spawn a process to exit node after max_time
  config = Map.new
  config = Map.put config, :max_time, 	  String.to_integer(Enum.at(System.argv, 0))
  config = Map.put config, :node_suffix,  Enum.at(System.argv, 1)
  config = Map.put config, :start_function, :'#{Enum.at(System.argv, 2)}'

  spawn(Helper, :exit_after, [config.max_time])
  config
end # node_init

end # Helper

