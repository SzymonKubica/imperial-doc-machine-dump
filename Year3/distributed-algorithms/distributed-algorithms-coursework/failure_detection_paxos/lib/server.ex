# Modified by Szymon Kubica (sk4520) 18 Feb 2023
# distributed algorithms, n.dulay 31 jan 2023
# coursework, paxos made moderately complex

defmodule Server do
  def start(config, server_num, multipaxos) do
    config = Configuration.node_info(config, "Server", server_num)
    Debug.starting(config)

    database = spawn(Database, :start, [config])
    replica = spawn(Replica, :start, [config, database])
    leader = spawn(Leader, :start, [config])
    acceptor = spawn(Acceptor, :start, [config])

    send(multipaxos, {:MODULES, replica, acceptor, leader})

    if crash_after = config.crash_servers[server_num] do
      Process.sleep(crash_after)
      Process.exit(database, :faulty)
      Process.exit(replica, :faulty)
      Process.exit(leader, :faulty)
      Process.exit(acceptor, :faulty)
      IO.puts("  Server #{server_num} crashed at time #{crash_after}")
    end
  end
end
