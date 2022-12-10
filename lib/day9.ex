defmodule AdventOfCode.Day9 do
  @doc ~S"""
  Parses the `input` into a list of moves to be followed by the rope.

  ### Examples

      iex> File.read!("test/day9/input1.txt") |> Day9.parse
      [{"R", 4}, {"U", 4}, {"L", 3}, {"D", 1}, {"R", 4}, {"D", 1}, {"L", 5}, {"R", 2}]
  """
  def parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      case Regex.run(~r/([RLUD]) (\d+)/, line) do
        [_, direction, steps] -> {direction, String.to_integer(steps)}
      end
    end)
  end

  defp move([{x, y} | tail], direction) do
    head =
      case direction do
        "R" -> {x + 1, y}
        "L" -> {x - 1, y}
        "U" -> {x, y + 1}
        "D" -> {x, y - 1}
      end

    move_tail([head | tail], [])
  end

  defp move_tail([{head_x, head_y} = head, {x, y} | tail], output) do
    {x, y} =
      if abs(head_x - x) <= 1 and abs(head_y - y) <= 1 do
        {x, y}
      else
        {
          if x == head_x do x else if x < head_x do x + 1 else x - 1 end end,
          if y == head_y do y else if y < head_y do y + 1 else y - 1 end end
        }
      end
    move_tail([{x, y} | tail], [head | output])
  end

  defp move_tail([head | _], output) do
    Enum.reverse([head | output])
  end

  defp run(moves, knots) do
    {_, tail_positions} =
      moves
      |> Enum.reduce({List.duplicate({0, 0}, knots), []}, fn
        {direction, steps}, acc ->
          Enum.reduce(1..steps, acc, fn
            _, {rope, tail_positions} ->
              rope = move(rope, direction)
              {rope, [List.last(rope) | tail_positions]}
          end)
      end)

    tail_positions
    |> Enum.uniq
    |> Enum.count
  end

  @doc ~S"""
  Simulates the rope following the given set of `moves`, assuming a rope with
  two knots, and returns the number of positions the final knot at the end of
  the rope has visited.

  ### Examples

      iex> File.read!("test/day9/input1.txt") |> Day9.parse |> Day9.two_knots
      13

      iex> File.read!("test/day9/input3.txt") |> Day9.parse |> Day9.two_knots
      6332
  """
  def two_knots(moves), do: run(moves, 2)

  @doc ~S"""
  Simulates the rope following the given set of `moves`, assuming a rope with
  ten knots, and returns the number of positions the final knot at the end of
  the rope has visited.

  ### Examples

      iex> File.read!("test/day9/input1.txt") |> Day9.parse |> Day9.ten_knots
      1

      iex> File.read!("test/day9/input2.txt") |> Day9.parse |> Day9.ten_knots
      36

      iex> File.read!("test/day9/input3.txt") |> Day9.parse |> Day9.ten_knots
      2511
  """
  def ten_knots(moves), do: run(moves, 10)
end
