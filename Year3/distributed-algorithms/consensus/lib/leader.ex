# Modified by Szymon Kubica (sk4520) Feb 2023
defmodule Leader do
  @compile if Mix.env() == :test, do: :export_all

  # ____________________________________________________________________ Setters

  defp add_proposal(self, proposal) do
    %{self | proposals: MapSet.put(self.proposals, proposal)}
  end

  defp activate(self) do
    %{self | active: true}
  end

  defp deactivate(self) do
    %{self | active: false}
  end

  defp update_ballot_number(self, new_value) do
    %{
      self
      | ballot_num: %BallotNumber{self.ballot_num | value: new_value + 1}
    }
  end

  # The functions below deal with updating the timeout that the leader sets
  # for each of its ballots. They are used only when the operation mode is
  # :full_liveness and are a no-op otherwise.

  defp increase_timeout(self) do
    case self.config.operation_mode do
      :full_liveness ->
        base_value = max(self.timeout, self.config.initial_leader_timeout)

        new_timeout =
          min(
            self.config.max_leader_timeout,
            round(base_value * self.config.leader_timeout_increase_factor)
          )

        self
        |> update_timeout(new_timeout)
        |> Monitor.notify(:TIMEOUT_INCREASED, self.timeout)

      _ ->
        self
    end
  end

  defp decrease_timeout(self) do
    case self.config.operation_mode do
      :full_liveness ->
        new_timeout =
          max(
            self.config.min_leader_timeout,
            self.timeout - self.config.leader_timeout_decrease_const
          )

        self
        |> update_timeout(new_timeout)
        |> Monitor.notify(:TIMEOUT_DECREASED, self.timeout)

      _ ->
        self
    end
  end

  defp update_timeout(self, new_timeout) do
    %{self | timeout: new_timeout}
  end

  defp set_preempted_by(self, b) do
    %{self | preempted_by: b}
  end

  # ____________________________________________________________________________

  def start(config) do
    {acceptors, replicas} =
      receive do
        {:BIND, acceptors, replicas} -> {acceptors, replicas}
      end

    self = %{
      type: :leader,
      config: config,
      ballot_num: %BallotNumber{value: 0, leader: self()},
      timeout: config.initial_leader_timeout,
      acceptors: acceptors,
      replicas: replicas,
      failure_detector: nil,
      active: false,
      proposals: MapSet.new(),
      preempted_by: nil
    }

    self
    |> spawn_scout
    |> spawn_failure_detector
    |> next
  end

  def next(self) do
    Debug.letter(self.config, "L")

    receive do
      {:RESPONSE_REQUESTED, requestor} ->
        cond do
          self.active ->
            send(requestor, {:STILL_ALIVE, self.ballot_num, self.timeout})
            self |> Monitor.notify(:PING_RESPONSE_SENT)

          self.preempted_by != nil ->
            send(requestor, {:STILL_ALIVE, self.preempted_by, self.timeout})
            self |> Monitor.notify(:PING_RESPONSE_SENT)

          true ->
            :skip
        end

        self |> next

      {:PROPOSE, s, c} ->
        self = self |> Debug.log("PROPOSE received: command: #{inspect(c)} in slot #{s}")

        if self |> exists_proposal_for?(s), do: self |> next

        proposal = {s, c}

        self =
          self
          |> Debug.log("Slot #{s} empty, adding a proposal: #{inspect({s, c})}")
          |> add_proposal(proposal)
          |> Debug.log("Proposals: #{MapSet.size(self.proposals)} \n #{inspect(self.proposals)}")

        if not self.active, do: self |> next

        self
        |> spawn_commander({self.ballot_num, s, c})
        |> Debug.log("Commander spawned for: #{inspect(c)} in slot #{s}", :success)
        |> next

      {:PROPOSAL_CHOSEN} ->
        # This message is sent to the leader by the commander after it has been
        # successfully accepted by the acceptors and sent the :DECISION message to the
        # replicas. It is done to achieve the additive decrease of the timeout associated
        # with the ballot number with each proposal chosen for that ballot.
        self
        |> decrease_timeout
        |> next

      {:ADOPTED, b, pvalues} ->
        # If an old ballot has been adopted, we ignore it.
        if not BallotNumber.equal?(b, self.ballot_num), do: self |> next

        self =
          self
          |> Debug.log("ADOPTED received: ballot: #{inspect(b)}", :success)
          |> Debug.log(
            "Proposals before update #{inspect(self.proposals)}\n" <>
              "--> Pvalues: #{inspect(pvalues)}\n" <>
              "--> Pmax: #{inspect(pmax(pvalues))}"
          )
          |> update_proposals(pmax(pvalues))
          |> Debug.log("Proposals after update #{inspect(self.proposals)}")

        commander_spawning_logs =
          for {s, c} <- self.proposals, into: [] do
            spawn_commander(self, {b, s, c})
            "Commander spawned: command: #{inspect(c)} in slot #{s}"
          end

        self
        |> Debug.log(Enum.join(commander_spawning_logs, "\n--> "))
        |> set_preempted_by(nil)
        |> activate
        |> next

      {:PREEMPTED, %BallotNumber{value: value} = b} ->
        self = self |> Debug.log("Received PREEMPTED message for ballot #{inspect(b)}", :error)

        # Here I needed to switch conditionally depending on which operation mode
        # was selected. It makes the code a bit less readable, but that way I don't have
        # four different versions of the mix project as it would be difficult to see
        # where they acutally differ.
        case self.config.operation_mode do
          :no_liveness ->
            if BallotNumber.less_or_equal?(b, self.ballot_num), do: self |> next

            self
            |> update_ballot_number(value)
            |> spawn_scout

          :partial_liveness ->
            if BallotNumber.less_or_equal?(b, self.ballot_num), do: self |> next

            Process.sleep(
              Enum.random(self.config.min_random_timeout..self.config.max_random_timeout)
            )

            self
            |> update_ballot_number(value)
            |> spawn_scout

          :simplified_liveness ->
            send(self.failure_detector, {:PING, b})
            self |> set_preempted_by(b)

          :full_liveness ->
            send(self.failure_detector, {:PING, b})
            self |> set_preempted_by(b)
        end
        |> deactivate
        |> next

      {:PREEMPT, %BallotNumber{value: value} = b} ->
        # This message is sent by the failure detector module if the leader that
        # we are currently pinging fails to respond within the specified timeout. In that
        # case we check if the incoming ballot is greater than what we currently have and
        # if so we pick an even higher one and spawn the scout.
        if BallotNumber.less_or_equal?(b, self.ballot_num), do: self |> next

        self
        |> increase_timeout
        |> update_ballot_number(value)
        |> spawn_scout
        |> next
    end
  end

  defp exists_proposal_for?(self, slot_number) do
    proposals = for {^slot_number, _c} = proposal <- self.proposals, do: proposal
    length(proposals) > 0
  end

  defp update_proposals(self, max_pvals) do
    remaining_proposals =
      for {s, _c} = proposal <- self.proposals,
          not update_exists?(s, max_pvals),
          into: MapSet.new(),
          do: proposal

    %{self | proposals: MapSet.union(max_pvals, remaining_proposals)}
  end

  defp update_exists?(slot_number, proposals) do
    updates = for {^slot_number, _c} = proposal <- proposals, do: proposal
    length(updates) != 0
  end

  defp pmax(pvalues) do
    for %Pvalue{ballot_num: b, slot_num: s, command: c} <- pvalues,
        Enum.all?(
          for %Pvalue{ballot_num: b1, slot_num: ^s} <- pvalues,
              do: BallotNumber.less_or_equal?(b1, b)
        ),
        into: MapSet.new(),
        do: {s, c}
  end

  # __________________________________________ Functions for spawning submodules

  defp spawn_failure_detector(self) do
    # This function spawns an appropriate failure detector module depending on the
    # operation mode. If the mode doesn't require a failure detector it is a no-op.
    mode = self.config.operation_mode

    if mode in [:full_liveness, :simplified_liveness] do
      failure_detector =
        case self.config.operation_mode do
          :full_liveness ->
            spawn(FailureDetector, :start, [self.config, self()])

          :simplified_liveness ->
            spawn(SimpleFailureDetector, :start, [self.config, self()])
        end

      self = self |> Monitor.notify(:FAILURE_DETECTOR_SPAWNED)
      %{self | failure_detector: failure_detector}
    else
      self
    end
  end

  defp spawn_commander(self, {b, s, c}) do
    spawn(Commander, :start, [
      self.config,
      self(),
      self.acceptors,
      self.replicas,
      %Pvalue{ballot_num: b, slot_num: s, command: c}
    ])

    self |> Monitor.notify(:COMMANDER_SPAWNED)
  end

  defp spawn_scout(self) do
    spawn(Scout, :start, [self.config, self(), self.acceptors, self.ballot_num])

    self |> Monitor.notify(:SCOUT_SPAWNED)
  end

  # ____________________________________________________________________________
end
