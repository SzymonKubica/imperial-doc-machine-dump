# Modified by Szymon Kubica (sk4520) Feb 2023
defmodule SimpleFailureDetector do
  # ____________________________________________________________________ Setters

  defp update_ballot_number_if_greater(self, ballot_num) do
    if BallotNumber.greater_than?(ballot_num, self.ballot_num),
      do: %{self | ballot_num: ballot_num},
      else: self
  end

  # ____________________________________________________________________________

  def start(config, l) do
    self = %{
      type: :failure_detector,
      config: config,
      leader: l,
      ballot_num: BallotNumber.bottom()
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
    self |> Monitor.notify(:PING_SENT)

    receive do
      # Here the timeout is ignored to expose the same api to the leader so
      # that the SimpleFailureDetector can replace a regular failure detector
      {:STILL_ALIVE, current_ballot, _timeout} ->
        Process.sleep(self.config.simple_fd_timeout)

        self
        |> update_ballot_number_if_greater(current_ballot)
        |> Monitor.notify(:PING_RESPONSE_RECEIVED)
        |> ping
    after
      self.config.simple_fd_timeout ->
        send(self.leader, {:PREEMPT, self.ballot_num})

        self
        |> Monitor.notify(:PING_FINISHED)
        |> next
    end
  end
end
