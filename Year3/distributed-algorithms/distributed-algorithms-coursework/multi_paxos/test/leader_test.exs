  defmodule LeaderTest do
    use ExUnit.Case
    doctest Leader

    test "pmax for each slot returns the command from highest ballot " do
      b0 = %BallotNumber{value: 0, leader_index: 0}
      b1 = %BallotNumber{value: 1, leader_index: 1}
      b2 = %BallotNumber{value: 1, leader_index: 2}
      b3 = %BallotNumber{value: 0, leader_index: 3}

      pvalues = [{b0, 0, :command0}, {b1, 1, :command1}, {b2, 1, :command2}, {b3, 0, :command3}] |> MapSet.new()

      assert Leader.pmax(pvalues) == MapSet.new([{0, :command3}, {1,:command2}])
    end

    test "update(x,y) return elements of y and the ones in x which are not in y" do
      b0 = %BallotNumber{value: 0, leader_index: 0}
      b1 = %BallotNumber{value: 1, leader_index: 1}
      b2 = %BallotNumber{value: 1, leader_index: 2}
      b3 = %BallotNumber{value: 0, leader_index: 3}

      self = %{proposals: MapSet.new([{0, :command0}, {1, :command1}, {2, :command4}])}
      pvalues = [{1, :command2}, {0, :command3}] |> MapSet.new()

      assert Leader.update_proposals(self, pvalues).proposals == MapSet.new([{2, :command4},{1, :command2},{0, :command3}])
    end
  end
