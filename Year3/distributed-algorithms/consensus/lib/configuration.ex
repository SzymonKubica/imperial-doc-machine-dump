# Modified by Szymon Kubica (sk4520) Feb 2023
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
      # Run configuration name used by monitor when writing logs to a file
      run_configuration: :default,
      # Controls if we want to write numbers of requests done to a file for evaluation.
      write_to_file: false,
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
      # server_num => crash_after_time(ms)
      crash_servers: %{},

      # controls if the liveness implementation is being used
      # supported values:
      # :no_liveness         - spawns scouts immediately after preempted,
      # :partial_liveness    - waits randomly after preemption,
      # :simplified_liveness - just pinging with a static timeout,
      # :full_liveness       - full AIMD-like timeouts and pinging from the paper.
      operation_mode: :no_liveness,

      # random leader preemption timeout bounds for the partial liveness fix (in ms).
      min_random_timeout: 100,
      max_random_timeout: 1000,

      # static ping timeout for the simplified liveness
      simple_fd_timeout: 2000,

      # AIMD-like timeout scaling factors for liveness
      leader_timeout_increase_factor: 1.2,
      leader_timeout_decrease_const: 10,
      initial_leader_timeout: 1000,
      min_leader_timeout: 500,
      max_leader_timeout: 5000,

      # Logger settings for debugging
      logger_level: %{
        monitor: :quiet,
        database: :quiet,
        replica: :quiet,
        client: :quiet,
        leader: :quiet,
        commander: :quiet,
        acceptor: :quiet,
        scout: :quiet,
        failure_detector: :quiet
      }
    }
  end

  # This configuration was used for debugging, it allows for specifying the
  # level of verbosity of the logs outputted by each of the modules. The
  # supported values are:
  # :quiet - no logs
  # :error - only logs with errors/unsuccessful requests (e.g. preemption)
  # :success - all errors plus messages with successful actions (e.g. decision made)
  # :verbose - all logs
  # I found this to be particularly useful for debugging the initial implementation
  # of multi-paxos as it allows for tracing how each of the modules processes e.g. a
  # single proposal for some slot
  def params(:debug) do
    Map.merge(
      params(:default),
      %{
        logger_level: %{
          monitor: :quiet,
          database: :verbose,
          replica: :verbose,
          client: :quiet,
          leader: :quiet,
          commander: :quiet,
          acceptor: :verbose,
          scout: :quiet,
          failure_detector: :verbose
        }
      }
    )
  end

  # -----------------------------------------------------------------------------

  # I used this configuration to test the if the initial implementation of the
  # algorithm was correct. In order to get all requests processes one has to
  # wait for about 2 minutes and so it requires setting the MAX_TIME variable
  # in the Makefile to be appropriately high. This one definitely livelocks.
  # An interesting finding was that when tested with various machines (lab machine,
  # laptop with 11-th Gen Intel i7-1165G7, some older hardware), the effects of
  # the livelock seem to be less severe when run on a slower machine.
  def params(:no_liveness_short) do
    Map.merge(
      params(:default),
      %{
        run_configuration: :no_liveness_short,
        max_requests: 5
      }
    )
  end

  def params(:no_liveness_medium) do
    Map.merge(
      params(:default),
      %{
        run_configuration: :no_liveness_medium,
        max_requests: 500
      }
    )
  end

  # This configuration allows for testing the :partial_liveness operation mode.
  # That setting is effectively a cheap solution for livelocks which makes each leader
  # sleep for some time after being preempted. It seems to solve liveness issues when
  # the number of requests is very small
  def params(:partial_liveness_short) do
    Map.merge(
      params(:default),
      %{
        run_configuration: :partial_liveness_short,
        operation_mode: :partial_liveness,
        max_requests: 5,
        min_random_timeout: 10,
        max_random_timeout: 100
      }
    )
  end

  # This configuration pushes the quick-fix :partial_liveness configuration to its
  # limits, we can observe that when we increase the number of requests to process,
  # the algorithm still livelocks. It is interesting to note that if we increase
  # the min_random_timeout, it is more likely that the congestion for the acceptors
  # will be minimised and we actually get the system to process all requests.

  def params(:partial_liveness_medium) do
    Map.merge(
      params(:default),
      %{
        run_configuration: :partial_liveness_medium,
        operation_mode: :partial_liveness,
        max_requests: 500,
        min_random_timeout: 100,
        max_random_timeout: 1000
      }
    )
  end

  # I found that when we increased the number of requests, the probability of it
  # livelock-ing is much higher. This one almost always livelocked on my machine.
  def params(:partial_liveness_long) do
    Map.merge(
      params(:default),
      %{
        run_configuration: :partial_liveness_long,
        operation_mode: :partial_liveness,
        max_requests: 2000,
        min_random_timeout: 10,
        max_random_timeout: 100
      }
    )
  end

  # In this configuration we still get a livelock even though two of the five
  # servers have crashed.
  def params(:crash2) do
    Map.merge(
      params(:default),
      %{
        run_configuration: :crash2,
        crash_servers: %{
          3 => 1_500,
          5 => 2_500
        }
      }
    )
  end

  # In this configuration we test the same crash but with partial_liveness settings.
  def params(:partial_liveness_crash2) do
    Map.merge(
      params(:partial_liveness_medium),
      %{
        run_configuration: :partial_liveness_crash2,
        crash_servers: %{
          3 => 1_500,
          5 => 2_500
        }
      }
    )
  end

  # This configuration enables the full liveness for the default config. It is able
  # to process 2500 requests in about 5 seconds on my machine.
  def params(:full_liveness) do
    Map.merge(
      params(:default),
      %{
        run_configuration: :full_liveness,
        operation_mode: :full_liveness
      }
    )
  end

  def params(:full_liveness_long) do
    Map.merge(
      params(:default),
      %{
        max_requests: 2000,
        run_configuration: :full_liveness_long,
        operation_mode: :full_liveness
      }
    )
  end

  # This one stress-tests the liveness implementation
  def params(:full_liveness_stress) do
    Map.merge(
      params(:default),
      %{
        run_configuration: :full_liveness_stress,
        max_requests: 5000,
        client_stop: 20_000,
        operation_mode: :full_liveness
      }
    )
  end

  # This configuration shows the problem with the AIMD-like changing of the timeouts
  # if the settings that we pick are not calibrated correctly, e.g. the minimum
  # ballot timeout is to low or the timeout decreases too quickly, the leader will
  # be able to process only a couple of requests before it gets preempted and then
  # the contention will increase substantially, as all of the other leaders that
  # were waiting for him will spawn their scouts at the same time. That could impact
  # the performance of the system. During experimentation I noticed that it is
  # desirable to have one leader decide on virtually all requests and the others
  # just ping it periodically. That way the time wasted on spawning scouts and
  # performing the phase 1 of the synod protocol is minimised. The configuration
  # below illustrates how incorrectly-tuned parameters for changing the timeouts
  # can lead to bad performance of the system.
  def params(:full_liveness_bad_settings) do
    Map.merge(
      params(:default),
      %{
        run_configuration: :full_liveness_bad_settings,
        max_requests: 2000,
        client_stop: 20_000,
        operation_mode: :full_liveness,
        leader_timeout_increase_factor: 1.2,
        leader_timeout_decrease_const: 25,
        initial_leader_timeout: 500,
        min_leader_timeout: 5,
        max_leader_timeout: 5000
      }
    )
  end

  # This configuration runs the liveness implementation using the SimpleFailureDetector
  # modules which have a static timeout and continue pinging as long as the leader
  # keeps responding. It uses the same number of requests settings as the one above
  # to be able to contrast the two approaches during evalutation
  # The fail detection timeout is quite generous to make sure that the main leader
  # that is working on all decisions has enough time to process them without being
  # preempted.
  def params(:simplified_liveness) do
    Map.merge(
      params(:default),
      %{
        max_requests: 2000,
        simple_fd_timeout: 2000,
        run_configuration: :simplified_liveness,
        operation_mode: :simplified_liveness
      }
    )
  end

  # In this configuration we test a crash of 2 servers with liveness
  def params(:crash2_liveness) do
    Map.merge(
      params(:full_liveness_long),
      %{
        run_configuration: :crash2_liveness,
        crash_servers: %{
          5 => 20_000,
          3 => 22_000
        }
      }
    )
  end
end

# Configuration ----------------------------------------------------------------
