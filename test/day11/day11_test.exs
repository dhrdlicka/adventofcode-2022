defmodule AdventOfCode.Day11Test do
  use ExUnit.Case
  alias AdventOfCode.Day11
  doctest Day11

  test "monkeys are correctly parsed" do
    {monkeys, _} =
      File.read!("test/day11/input1.txt")
      |> Day11.parse

    assert match? [
      %{divisor: 23, false: 3, number: 0, true: 2},
      %{divisor: 19, false: 0, number: 1, true: 2},
      %{divisor: 13, false: 3, number: 2, true: 1},
      %{divisor: 17, false: 1, number: 3, true: 0}
    ], monkeys
  end
end
