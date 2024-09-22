# Modified by Szymon Kubica (sk4520) Feb 2023
defmodule FailureDetector do
  # ____________________________________________________________________ Setters

  defp update_ballot_number_if_greater(self, ballot_num) do
    if BallotNumber.greater_than?(ballot_num, self.ballot_num),
      do: %{self | ballot_num: ballot_num},
      else: self
  end

  defp update_timeout(self, timeout) do
    %{self | timeout: timeout}
  end

  # ____________________________________________________________________________

  def start(config, l) do
    self = %{
      type: :failure_detector,
      config: config,
      leader: l,
      ballot_num: BallotNumber.bottom(),
      timeout: config.initial_leader_timeout
    }

    self |> next
  end

  defp next(self) do
    Debug.letter(self.config, "F")

    receive do
      {:PING, ballot_num} ->
        self
        |> update_ballot_number_if_greater(ballot_num)
        |> ping
    end
    |> next
  end

  defp ping(self) do
    preempting_leader = self.ballot_num.leader
    send(preempting_leader, {:RESPONSE_REQUESTED, self()})

    self
    |> Debug.log("Ping message sent to Leader: #{inspect(preempting_leader)}")
    |> Monitor.notify(:PING_SENT)

    receive do
      {:STILL_ALIVE, current_ballot, timeout} ->
        Process.sleep(self.timeout)

        self
        |> update_ballot_number_if_greater(current_ballot)
        |> Monitor.notify(:PING_RESPONSE_RECEIVED)
        |> Debug.log("Ping response received, current timeout: #{timeout}")
        |> update_timeout(timeout)
        |> ping
    after
      self.timeout ->
        send(self.leader, {:PREEMPT, self.ballot_num})

        self
        |> Monitor.notify(:PING_FINISHED)
        |> Debug.log(
          "Leader #{inspect(self.ballot_num.leader)} failed to respond within: #{self.timeout} [ms], pinging stopped."
        )
        |> next
    end
  end
end
