# Modified by Szymon Kubica (sk4520) Feb 2023
# distributed algorithms, n.dulay 31 jan 2023
# coursework, paxos made moderately complex

defmodule Monitor do
  # _______________________________________________________________________ Setters

  def clock(self, v) do
    Map.put(self, :clock, v)
  end

  def seen(self, k, v) do
    Map.put(self, :seen, Map.put(self.seen, k, v))
  end

  def done(self, k, v) do
    Map.put(self, :done, Map.put(self.done, k, v))
  end

  def log(self, k, v) do
    Map.put(self, :log, Map.put(self.log, k, v))
  end

  def commanders_spawned(self, k, v) do
    Map.put(self, :commanders_spawned, Map.put(self.commanders_spawned, k, v))
  end

  def commanders_preempted(self, k, v) do
    Map.put(self, :commanders_preempted, Map.put(self.commanders_preempted, k, v))
  end

  def commanders_finished(self, k, v) do
    Map.put(self, :commanders_finished, Map.put(self.commanders_finished, k, v))
  end

  def scouts_spawned(self, k, v) do
    Map.put(self, :scouts_spawned, Map.put(self.scouts_spawned, k, v))
  end

  def scouts_preempted(self, k, v) do
    Map.put(self, :scouts_preempted, Map.put(self.scouts_preempted, k, v))
  end

  def scouts_finished(self, k, v) do
    Map.put(self, :scouts_finished, Map.put(self.scouts_finished, k, v))
  end

  def failure_detectors_spawned(self, k, v) do
    Map.put(self, :failure_detectors_spawned, Map.put(self.failure_detectors_spawned, k, v))
  end

  def failure_detectors_finished(self, k, v) do
    Map.put(self, :failure_detectors_finished, Map.put(self.failure_detectors_finished, k, v))
  end

  def timeout_increased(self, k, v) do
    Map.put(self, :timeout_increased, Map.put(self.timeout_increased, k, v))
  end

  def timeout_updated(self, k, v) do
    Map.put(self, :leader_timeouts, Map.put(self.leader_timeouts, k, v))
  end

  def timeout_decreased(self, k, v) do
    Map.put(self, :timeout_decreased, Map.put(self.timeout_decreased, k, v))
  end

  def timeout_update_count(self, k, v) do
    Map.put(self, :leader_timeout_update_counts, Map.put(self.leader_timeout_update_counts, k, v))
  end

  def pings_sent(self, k, v) do
    Map.put(self, :pings_sent, Map.put(self.pings_sent, k, v))
  end

  def ping_responses_sent(self, k, v) do
    Map.put(self, :ping_responses_sent, Map.put(self.ping_responses_sent, k, v))
  end

  def pings_received(self, k, v) do
    Map.put(self, :pings_received, Map.put(self.pings_received, k, v))
  end

  # __________________________________________________________________________

  # This one ensures that each server always has its corresponding entry in the
  # map, even if it didn't send any messages associated with that constant. It
  # makes the output of the monitor more readable
  def empty_totals(config) do
    for i <- 1..config.n_servers, into: Map.new() do
      {i, 0}
    end
  end

  def start(config) do
    self = %{
      type: :monitor,
      config: config,
      clock: 0,
      seen: Map.new(),
      done: Map.new(),
      log: Map.new(),
      scouts_spawned: empty_totals(config),
      scouts_preempted: empty_totals(config),
      scouts_finished: empty_totals(config),
      commanders_spawned: empty_totals(config),
      commanders_preempted: empty_totals(config),
      commanders_finished: empty_totals(config),
      failure_detectors_spawned: empty_totals(config),
      failure_detectors_finished: empty_totals(config),
      leader_timeouts: empty_totals(config),
      timeout_increased: empty_totals(config),
      timeout_decreased: empty_totals(config),
      leader_timeout_update_counts: empty_totals(config),
      pings_sent: empty_totals(config),
      ping_responses_sent: empty_totals(config),
      pings_received: empty_totals(config)
    }

    self
    |> start_print_timeout()
    |> next()
  end

  def next(self) do
    receive do
      {:DB_MOVE, db, seqnum, transaction} = msg ->
        self = self |> Debug.log("DB_MOVE received: #{inspect(msg)}", :success)
        {:MOVE, amount, from, to, _id} = transaction
        done = Map.get(self.done, db, 0)
        expecting = done + 1

        if seqnum != expecting do
          Helper.node_halt("  ** error db #{db}: seq #{seqnum} expecting #{expecting}")
        end

        self =
          case Map.get(self.log, seqnum) do
            nil ->
              self |> log(seqnum, %{amount: amount, from: from, to: to})

            # already logged - check transaction against logged value (t)
            t ->
              if amount != t.amount or from != t.from or to != t.to do
                Helper.node_halt(
                  "Monitor:  ** error db #{db}.#{done} [#{amount},#{from},#{to}] " <>
                    "= log #{done}/#{map_size(self.log)} [#{t.amount},#{t.from},#{t.to}]"
                )
              end

              self
          end

        self
        |> done(db, seqnum)
        |> next()

      # client requests seen by replicas
      {:CLIENT_REQUEST, server_num} ->
        value = Map.get(self.seen, server_num, 0)

        self
        |> seen(server_num, value + 1)
        |> next()

      {:SCOUT_SPAWNED, server_num} ->
        value = Map.get(self.scouts_spawned, server_num, 0)

        self
        |> scouts_spawned(server_num, value + 1)
        |> next()

      {:SCOUT_PREEMPTED, server_num} ->
        value = Map.get(self.scouts_preempted, server_num, 0)

        self
        |> scouts_preempted(server_num, value + 1)
        |> next()

      {:SCOUT_FINISHED, server_num} ->
        value = Map.get(self.scouts_finished, server_num, 0)

        self
        |> scouts_finished(server_num, value + 1)
        |> next()

      {:COMMANDER_SPAWNED, server_num} ->
        value = Map.get(self.commanders_spawned, server_num, 0)

        self
        |> commanders_spawned(server_num, value + 1)
        |> next()

      {:COMMANDER_PREEMPTED, server_num} ->
        value = Map.get(self.commanders_preempted, server_num, 0)

        self
        |> commanders_preempted(server_num, value + 1)
        |> next()

      {:COMMANDER_FINISHED, server_num} ->
        value = Map.get(self.commanders_finished, server_num, 0)

        self
        |> commanders_finished(server_num, value + 1)
        |> next()

      {:PING_FINISHED, server_num} ->
        value = Map.get(self.failure_detectors_finished, server_num, 0)

        self
        |> failure_detectors_finished(server_num, value + 1)
        |> next()

      {:FAILURE_DETECTOR_SPAWNED, server_num} ->
        value = Map.get(self.failure_detectors_spawned, server_num, 0)

        self
        |> failure_detectors_spawned(server_num, value + 1)
        |> next()

      {:PING_SENT, server_num} ->
        value = Map.get(self.pings_sent, server_num, 0)

        self
        |> pings_sent(server_num, value + 1)
        |> next()

      {:PING_RESPONSE_RECEIVED, server_num} ->
        value = Map.get(self.pings_received, server_num, 0)

        self
        |> pings_received(server_num, value + 1)
        |> next()

      {:PING_RESPONSE_SENT, server_num} ->
        value = Map.get(self.ping_responses_sent, server_num, 0)

        self
        |> ping_responses_sent(server_num, value + 1)
        |> next()

      {:TIMEOUT_INCREASED, leader_num, new_timeout_value} ->
        value = Map.get(self.leader_timeout_update_counts, leader_num, 0)
        increase_counts = Map.get(self.timeout_increased, leader_num, 0)

        self
        |> timeout_updated(leader_num, new_timeout_value)
        |> timeout_increased(leader_num, increase_counts + 1)
        |> timeout_update_count(leader_num, value + 1)
        |> next()

      {:TIMEOUT_DECREASED, leader_num, new_timeout_value} ->
        value = Map.get(self.leader_timeout_update_counts, leader_num, 0)
        decrease_counts = Map.get(self.timeout_decreased, leader_num, 0)

        self
        |> timeout_updated(leader_num, new_timeout_value)
        |> timeout_decreased(leader_num, decrease_counts + 1)
        |> timeout_update_count(leader_num, value + 1)
        |> next()

      {:PRINT} ->
        clock = self.clock + self.config.print_after
        self = self |> clock(clock)

        sorted = self.seen |> Map.to_list() |> List.keysort(0)
        IO.puts("time = #{clock} client requests seen = #{inspect(sorted)}")
        sorted = self.done |> Map.to_list() |> List.keysort(0)
        IO.puts("time = #{clock}     db requests done = #{inspect(sorted)}")

        cond do
          self.config.debug_level > 1 ->
            sorted = self.scouts_spawned |> Map.to_list() |> List.keysort(0)
            IO.puts("time = #{clock}            scouts up = #{inspect(sorted)}")
            sorted = self.scouts_preempted |> Map.to_list() |> List.keysort(0)
            IO.puts("time = #{clock}     scouts preempted = #{inspect(sorted)}")
            sorted = self.scouts_finished |> Map.to_list() |> List.keysort(0)
            IO.puts("time = #{clock}          scouts down = #{inspect(sorted)}")

            sorted = self.commanders_spawned |> Map.to_list() |> List.keysort(0)
            IO.puts("time = #{clock}        commanders up = #{inspect(sorted)}")
            sorted = self.commanders_preempted |> Map.to_list() |> List.keysort(0)
            IO.puts("time = #{clock} commanders preempted = #{inspect(sorted)}")
            sorted = self.commanders_finished |> Map.to_list() |> List.keysort(0)
            IO.puts("time = #{clock}      commanders down = #{inspect(sorted)}")
            sorted = self.failure_detectors_spawned |> Map.to_list() |> List.keysort(0)
            IO.puts("time = #{clock}          FDs spawned = #{inspect(sorted)}")
            sorted = self.failure_detectors_finished |> Map.to_list() |> List.keysort(0)
            IO.puts("time = #{clock}       pings finished = #{inspect(sorted)}")
            sorted = self.leader_timeouts |> Map.to_list() |> List.keysort(0)
            IO.puts("time = #{clock}      leader timeouts = #{inspect(sorted)}")
            sorted = self.leader_timeout_update_counts |> Map.to_list() |> List.keysort(0)
            IO.puts("time = #{clock}      timeout updates = #{inspect(sorted)}")
            sorted = self.timeout_increased |> Map.to_list() |> List.keysort(0)
            IO.puts("time = #{clock}    timeout increases = #{inspect(sorted)}")
            sorted = self.timeout_decreased |> Map.to_list() |> List.keysort(0)
            IO.puts("time = #{clock}    timeout decreases = #{inspect(sorted)}")
            sorted = self.pings_sent |> Map.to_list() |> List.keysort(0)
            IO.puts("time = #{clock}   ping messages sent = #{inspect(sorted)}")
            sorted = self.pings_received |> Map.to_list() |> List.keysort(0)
            IO.puts("time = #{clock}       pings received = #{inspect(sorted)}")
            sorted = self.ping_responses_sent |> Map.to_list() |> List.keysort(0)
            IO.puts("time = #{clock}  ping responses sent = #{inspect(sorted)}")

          self.config.debug_level > 0 ->
            sorted = self.scouts_spawned |> Map.to_list() |> List.keysort(0)
            IO.puts("time = #{clock}            scouts up = #{inspect(sorted)}")
            sorted = self.scouts_finished |> Map.to_list() |> List.keysort(0)
            IO.puts("time = #{clock}          scouts down = #{inspect(sorted)}")
            sorted = self.commanders_spawned |> Map.to_list() |> List.keysort(0)
            IO.puts("time = #{clock}        commanders up = #{inspect(sorted)}")
            sorted = self.commanders_finished |> Map.to_list() |> List.keysort(0)
            IO.puts("time = #{clock}      commanders down = #{inspect(sorted)}")
        end

        if self.config.write_to_file do
          file_name = "outputs/requests_done/#{self.config.run_configuration}.txt"
          requests_done = for {_, x} <- sorted, do: Integer.to_string(x)

          File.open(file_name, [:append, :utf8], fn file ->
            IO.puts(file, "#{clock}, #{Enum.join(requests_done, ", ")}")
          end)
        end

        IO.puts("")

        self
        |> start_print_timeout()
        |> next()

      unexpected ->
        Helper.node_halt("monitor: unexpected message #{inspect(unexpected)}")
    end
  end

  def start_print_timeout(self) do
    Process.send_after(self(), {:PRINT}, self.config.print_after)
    self
  end

  def notify(entity, message, args \\ nil) do
    # If debug level is 1, we don't need to send all messages.
    level_1_messages = [
      :CLIENT_REQUEST,
      :SCOUT_SPAWNED,
      :SCOUT_FINISHED,
      :COMMANDER_SPAWNED,
      :COMMANDER_FINISHED
    ]

    message_payload =
      if args == nil,
        do: {message, entity.config.node_num},
        else: {message, entity.config.node_num, args}

    if entity.config.debug_level > 1 or message in level_1_messages do
      send(entity.config.monitor, message_payload)
    end

    entity
  end
end
