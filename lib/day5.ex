defmodule AdventOfCode.Day5 do
  @doc ~S"""
  Parses the given `input` into the current stack layout and a list of moves.

  ### Examples

      iex> File.read!("test/day5/input1.txt") |> Day5.parse
      {['NZ', 'DCM', 'P'], [{1, 1, 0}, {3, 0, 2}, {2, 1, 0}, {1, 0, 1}]}
  """
  def parse(input) do
    [stacks, moves] = String.split(input, "\n\n", trim: true)

    [acc | stacks] =
      stacks
      |> String.split("\n", trim: true)
      |> Enum.map(fn row ->
        row
        |> String.to_charlist
        |> Enum.chunk_every(4)
        |> Enum.map(fn
          [?[, char, ?] | _] -> [char]
          _ -> []
        end)
      end)
      |> Enum.reverse

    stacks =
      Enum.reduce(stacks, acc, &Enum.map(Enum.zip([&1, &2]), fn {crate, stack} -> crate ++ stack end))

    moves =
      moves
      |> String.split("\n", trim: true)
      |> Enum.map(fn move ->
        [_, amount, from, to] = Regex.run(~r/move (\d+) from (\d+) to (\d+)/, move)
        {String.to_integer(amount), String.to_integer(from) - 1, String.to_integer(to) - 1}
      end)

    {stacks, moves}
  end

  defp move(0, _, from, to), do: {from, to}
  defp move(amount, step, from, to) do
    crates = Enum.take(from, step)
    move(amount - step, step, Enum.drop(from, step), crates ++ to)
  end

  defp move_crates(stacks, moves, opts) do
    moves
    |> Enum.reduce(stacks, fn
      {amount, from, to}, stacks ->
        {from_stack, to_stack} =
          move(amount, if(Keyword.get(opts, :at_once), do: amount, else: 1), Enum.at(stacks, from), Enum.at(stacks, to))

        stacks
        |> List.replace_at(from, from_stack)
        |> List.replace_at(to, to_stack)
    end)
  end

  defp solve({stacks, moves}, opts) do
    stacks
    |> move_crates(moves, opts)
    |> Enum.map(fn [head | _] -> head end)
    |> List.to_string
  end

  @doc ~S"""
  Moves the stacked crates one at a time and then determines the crates on top
  of each stack.

  ### Examples

      iex> File.read!("test/day5/input1.txt") |> Day5.parse |> Day5.part_one
      "CMZ"

      iex> File.read!("test/day5/input2.txt") |> Day5.parse |> Day5.part_one
      "VRWBSFZWM"
  """
  def part_one(x), do: solve(x, at_once: false)

  @doc ~S"""
  Moves the stacked crates at once and then determines the crates on top of each
  stack.

  ### Examples

      iex> File.read!("test/day5/input1.txt") |> Day5.parse |> Day5.part_two
      "MCD"

      iex> File.read!("test/day5/input2.txt") |> Day5.parse |> Day5.part_two
      "RBTWJWMCF"
  """
  def part_two(x), do: solve(x, at_once: true)
end
