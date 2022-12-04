defmodule AdventOfCode.Day4 do
  @doc ~S"""
  Parses the given `input` into a list of pairs of section ranges.

  ### Examples

      iex> File.read!("test/day4/input1.txt") |> Day4.parse
      [{2..4, 6..8}, {2..3, 4..5}, {5..7, 7..9}, {2..8, 3..7}, {6..6, 4..6}, {2..6, 4..8}]
  """
  def parse(input) do
    input
    |> String.split(["\n", "-", ","], trim: true)
    |> Enum.map(&String.to_integer(&1))
    |> Enum.chunk_every(4)
    |> Enum.map(fn [a, b, c, d] -> {a..b, c..d} end)
  end

  @doc ~S"""
  Determines how many pairs of Elves have been assigned sections where one Elf's
  range is fully contained within the other's.

  ### Examples

      iex> File.read!("test/day4/input1.txt") |> Day4.parse |> Day4.fully_contained
      2

      iex> File.read!("test/day4/input2.txt") |> Day4.parse |> Day4.fully_contained
      509
  """
  def fully_contained(pairs) do
    pairs
    |> Enum.count(fn
      {a..b, c..d} when a <= c and d <= b -> true
      {a..b, c..d} when c <= a and b <= d -> true
      _ -> false
    end)
  end

  @doc ~S"""
  Determines how many pairs of Elves have been assigned sections that overlap.

  ### Examples

      iex> File.read!("test/day4/input1.txt") |> Day4.parse |> Day4.overlapping
      4

      iex> File.read!("test/day4/input2.txt") |> Day4.parse |> Day4.overlapping
      870
  """
  def overlapping(pairs) do
    Enum.count(pairs, fn {x, y} -> !Range.disjoint?(x, y) end)
  end
end
