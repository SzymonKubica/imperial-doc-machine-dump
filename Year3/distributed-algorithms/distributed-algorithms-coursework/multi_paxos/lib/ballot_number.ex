# Modified by Szymon Kubica (sk4520) 18 Feb 2023
defmodule BallotNumber do
  defstruct value: 0, leader_index: 0, is_bottom: false

  def compare(
        %BallotNumber{value: v1, leader_index: l1, is_bottom: bot1},
        %BallotNumber{value: v2, leader_index: l2, is_bottom: bot2}
      ) do
    cond do
      bot1 and bot2 -> :eq
      bot1 -> :lt
      bot2 -> :gt
      v1 < v2 -> :lt
      v1 > v2 -> :gt
      l1 < l2 -> :lt
      l1 > l2 -> :gt
      true -> :eq
    end
  end

  def equal?(b1, b2), do: compare(b1, b2) == :eq
  def less_than?(b1, b2), do: compare(b1, b2) == :lt
  def greater_than?(b1, b2), do: compare(b1, b2) == :gt
  def less_or_equal?(b1, b2), do: compare(b1, b2) != :gt
  def greater_or_equal?(b1, b2), do: compare(b1, b2) != :lt

  def bottom() do
    %BallotNumber{is_bottom: true}
  end
end
