defmodule AdventOfCode.Day3 do
  def parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn rucksack ->
      rucksack
      |> String.to_charlist
      |> Enum.map(fn
        item when item >= ?a and item <= ?z -> (item - ?a) + 1
        item when item >= ?A and item <= ?Z -> (item - ?A) + 27
      end)
    end)
  end

  defp intersect(first, second) do
    first -- (first -- second)
  end

  @doc ~S"""
  Calculates the sum of priorites of items that are in both compartments of an
  Elf's rucksack.

  ### Examples

      iex> File.read!("test/day3/input1.txt") |> Day3.parse |> Day3.items_in_both_compartments
      157

      iex> File.read!("test/day3/input2.txt") |> Day3.parse |> Day3.items_in_both_compartments
      8515
  """
  def items_in_both_compartments(rucksacks) do
    rucksacks
    |> Enum.map(&Enum.split(&1, div(length(&1), 2)))
    |> Enum.flat_map(fn {first, second} ->
      first
      |> intersect(second)
      |> Enum.uniq
    end)
    |> Enum.sum
  end

  @doc ~S"""
  Calculates the sum of priorites of the badges carried by each group of three
  Elves in their rucksacks.

  ### Examples

      iex> File.read!("test/day3/input1.txt") |> Day3.parse |> Day3.badges
      70

      iex> File.read!("test/day3/input2.txt") |> Day3.parse |> Day3.badges
      2434
  """
  def badges(rucksacks) do
    rucksacks
    |> Enum.chunk_every(3)
    |> Enum.flat_map(fn [first, second, third] ->
      first
      |> intersect(second)
      |> intersect(third)
      |> Enum.uniq
    end)
    |> Enum.sum
  end
end
