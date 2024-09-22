# Modified by Szymon Kubica (sk4520) 18 Feb 2023
defmodule Acceptor do
  # ____________________________________________________________________ Setters

  def update_ballot_num(self, ballot_num) do
    %{self | ballot_num: ballot_num}
  end

  def accept(self, pvalue) do
    %{self | accepted: MapSet.put(self.accepted, pvalue)}
  end

  # ____________________________________________________________________________

  def start(config) do
    self = %{
      type: :acceptor,
      config: config,
      ballot_num: BallotNumber.bottom(),
      accepted: MapSet.new()
    }

    self |> next
  end

  def next(self) do
    receive do
      {:p1a, l, b} ->
        self =
          self
          |> Debug.log("p1a received: ballot: #{inspect(b)}")
          |> adopt_ballot_if_greater_than_current(b)
          |> Debug.log("Sending p1b response for ballot: #{inspect(self.ballot_num)}")

        send(l, {:p1b, self(), self.ballot_num, self.accepted})
        self

      {:p2a, l, %Pvalue{ballot_num: b} = pvalue} ->
        send(l, {:p2b, self(), self.ballot_num})
        self |> accept_pvalue_if_ballot_matches(b, pvalue)

      unexpected ->
        self |> Debug.log("Unexpected message #{inspect(unexpected)}", :error)
    end
    |> next
  end

  defp adopt_ballot_if_greater_than_current(self, b) do
    if BallotNumber.greater_than?(b, self.ballot_num),
      do: self |> update_ballot_num(b),
      else: self
  end

  defp accept_pvalue_if_ballot_matches(self, b, pvalue) do
    if BallotNumber.equal?(b, self.ballot_num),
      do: self |> accept(pvalue),
      else: self
  end
end
