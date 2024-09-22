# Modified by Szymon Kubica (sk4520) 18 Feb 2023
# distributed algorithms, n.dulay, 31 jan 2023
# coursework, paxos made moderately complex

defmodule Configuration do
  def node_init do
    # get node arguments and spawn a process to exit node after max_time
    config = %{
      node_suffix: Enum.at(System.argv(), 0),
      timelimit: String.to_integer(Enum.at(System.argv(), 1)),
      debug_level: String.to_integer(Enum.at(System.argv(), 2)),
      n_servers: String.to_integer(Enum.at(System.argv(), 3)),
      n_clients: String.to_integer(Enum.at(System.argv(), 4)),
      param_setup: :"#{Enum.at(System.argv(), 5)}",
      start_function: :"#{Enum.at(System.argv(), 6)}"
    }

    spawn(Helper, :node_exit_after, [config.timelimit])
    config |> Map.merge(Configuration.params(config.param_setup))
  end

  def node_info(config, node_type, node_num \\ "") do
    Map.merge(
      config,
      %{
        node_type: node_type,
        node_num: node_num,
        node_name: "#{node_type}#{node_num}",
        node_location: Helper.node_string(),
        # for ordering output lines
        line_num: 0
      }
    )
  end

  # -----------------------------------------------------------------------------
  def params(:default) do
    %{
      # max requests each client will make
      max_requests: 500,
      # time (ms) to sleep before sending new request
      client_sleep: 2,
      # time (ms) to stop sending further requests
      client_stop: 15_000,
      # :round_robin, :quorum or :broadcast
      send_policy: :round_robin,
      # number of active bank accounts (init balance=0)
      n_accounts: 100,
      # max amount moved between accounts
      max_amount: 1_000,
      # print summary every print_after msecs (monitor)
      print_after: 1_000,
      # multi-paxos window size
      window_size: 10,
      # determines if a leader waits before retrying after being preempted
      wait_before_retrying: false,
      # maximum waiting time after preemption (miliseconds)
      max_wait_time: 400,
      # server_num => crash_after_time(ms)
      crash_servers: %{},
      logger_level: %{
        monitor: :quiet,
        database: :quiet,
        replica: :quiet,
        client: :quiet,
        leader: :quiet,
        commander: :quiet,
        acceptor: :quiet,
        scout: :quiet
      }
    }
  end

  # I found this configuration to livelock almost every time.
  def params(:few_requests) do
    Map.merge(
      params(:default),
      %{max_requests: 5}
    )
  end

  # This configuration was used for debugging when implementing the core algorithm
  # It allows for specifying how verbose should the logs coming from each component
  # be. It supports four operation modes:
  # :quiet -> no logs at all
  # :error -> logs only when something bad / undesired happens.
  # :success -> logs all errors plus successful steps (e.g. ballot adopted)
  # :verbose -> all logs are printed.
  def params(:debug) do
    Map.merge(
      params(:random_leader_wait_working),
      %{
        logger_level: %{
          monitor: :quiet,
          database: :verbose,
          replica: :verbose,
          client: :quiet,
          leader: :success,
          commander: :quiet,
          acceptor: :quiet,
          scout: :quiet
        }
      }
    )
  end

  # This configuration was introduced to partially solve the livelock problem.
  # It causes the leader to randomly sleep after it was preempted to increase
  # the chance of live locking. It fixes livelocks for small numbers of requests
  # e.g. 5 per client, however it doesn't affect higher congestion.
  def params(:random_leader_wait_working) do
    Map.merge(
      params(:few_requests),
      %{
        wait_before_retrying: true,
        min_wait_time: 100,
        max_wait_time: 1000
      }
    )
  end

  # Here there are too many requests so the random wait doesn't help.
  def params(:random_leader_wait_not_working) do
    Map.merge(
      params(:default),
      %{
        wait_before_retrying: true,
        min_wait_time: 100,
        max_wait_time: 1000
      }
    )
  end

  # -----------------------------------------------------------------------------

  # crash 2 servers
  def params(:crash2) do
    Map.merge(
      params(:default),
      %{
        # %{ server_num => crash_after_time, ...}
        crash_servers: %{
          3 => 1_500,
          5 => 2_500
        }
      }
    )
  end

  def params(:tenk) do
    Map.merge(
      params(:default),
      %{
        # redact definitions
      }
    )
  end

  # redact params functions...
end

# Configuration ----------------------------------------------------------------
