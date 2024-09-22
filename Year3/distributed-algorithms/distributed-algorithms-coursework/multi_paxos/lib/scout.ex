# Modified by Szymon Kubica (sk4520) 18 Feb 2023
defmodule Scout do
  # ____________________________________________________________________ Setters

  defp add_pvalues(self, pvalues) do
    %{self | pvalues: MapSet.union(self.pvalues, pvalues)}
  end

  defp remove_acceptor_from_waitfor(self, a) do
    %{self | waitfor: List.delete(self.waitfor, a)}
  end

  # ____________________________________________________________________________

  def start(config, l, acceptors, b) do
    self = %{
      type: :scout,
      config: config,
      leader: l,
      ballot_number: b,
      waitfor: acceptors,
      acceptors: acceptors,
      pvalues: MapSet.new()
    }

    for acceptor <- acceptors do
      send(acceptor, {:p1a, self(), b})
    end

    self |> next
  end

  def next(self) do
    receive do
      {:p1b, a, b, r} ->
        self =
          self
          |> Debug.log("p1b received:\n
              --> Acceptor: #{inspect(a)}\n
              --> Ballot number: #{inspect(b)}\n
              --> Pvalues: #{inspect(r)}.")

        if not BallotNumber.equal?(b, self.ballot_number) do
          send(self.leader, {:PREEMPTED, b})

          self
          |> Monitor.notify(:SCOUT_PREEMPTED)
          |> scout_finished
        end

        self =
          self
          |> remove_acceptor_from_waitfor(a)
          |> add_pvalues(r)

        if not majority_responded?(self), do: self |> next

        send(self.leader, {:ADOPTED, self.ballot_number, self.pvalues})
        self |> scout_finished
    end
  end

  defp majority_responded?(self) do
    length(self.waitfor) < div(length(self.acceptors) + 1, 2)
  end

  defp scout_finished(self) do
    self |> Monitor.notify(:SCOUT_FINISHED)
    Process.exit(self(), :normal)
  end
end
