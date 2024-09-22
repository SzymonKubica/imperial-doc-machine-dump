# Modified by Szymon Kubica (sk4520) 18 Feb 2023
defmodule Commander do
  # ____________________________________________________________________ Setters

  defp remove_acceptor_from_waitfor(self, a) do
    %{self | waitfor: List.delete(self.waitfor, a)}
  end

  # ____________________________________________________________________________

  def start(config, l, acceptors, replicas, pvalue) do
    self = %{
      type: :commander,
      config: config,
      leader: l,
      waitfor: acceptors,
      acceptors: acceptors,
      replicas: replicas,
      pvalue: pvalue
    }

    for acceptor <- acceptors do
      send(acceptor, {:p2a, self(), pvalue})
    end

    self |> next
  end

  defp next(self) do
    receive do
      {:p2b, a, b} ->
        self = self |> Debug.log("p2b received: ballot: #{inspect(b)}")

        if not BallotNumber.equal?(b, self.pvalue.ballot_num) do
          send(self.leader, {:PREEMPTED, b})

          self
          |> Monitor.notify(:COMMANDER_PREEMPTED)
          |> commander_finished
        end

        self = self |> remove_acceptor_from_waitfor(a)

        if not majority_accepted?(self), do: self |> next

        self |> Debug.log("Majority achieved for: #{inspect(self.pvalue)}", :success)

        for replica <- self.replicas,
            do: send(replica, {:DECISION, self.pvalue.slot_num, self.pvalue.command})

        self |> commander_finished
    end
  end

  defp majority_accepted?(self) do
    length(self.waitfor) < div(length(self.acceptors) + 1, 2)
  end

  defp commander_finished(self) do
    self |> Monitor.notify(:COMMANDER_FINISHED)
    Process.exit(self(), :normal)
  end
end
