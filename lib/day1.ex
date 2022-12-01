defmodule AdventOfCode.Day1 do
  @doc ~S"""
  Parses the given `input` into a two-level list of the numbers of calories
  per item and Elf.

  ### Examples

      iex> File.read!("test/day1/input1.txt") |> Day1.parse
      [[1000, 2000, 3000], [4000], [5000, 6000], [7000, 8000, 9000], [10000]]
  """
  def parse(input) do
    input
    |> String.split("\n\n", trim: true)
    |> Enum.map(fn elf ->
      elf
      |> String.split("\n", trim: true)
      |> Enum.map(&String.to_integer(&1))
    end)
  end

  @doc ~S"""
  Determines how many calories is the Elf carrying the most calories, carrying.

  ### Examples

      iex> File.read!("test/day1/input1.txt") |> Day1.parse |> Day1.top_elf
      24000

      iex> File.read!("test/day1/input2.txt") |> Day1.parse |> Day1.top_elf
      67633
  """
  def top_elf(elves) do
    elves
    |> Enum.map(&Enum.sum(&1))
    |> Enum.max
  end

  @doc ~S"""
  Determines how many calories are the top three Elves carrying the most
  calories, carrying.

  ### Examples

      iex> File.read!("test/day1/input1.txt") |> Day1.parse |> Day1.top_three_elves
      45000

      iex> File.read!("test/day1/input2.txt") |> Day1.parse |> Day1.top_three_elves
      199628
  """
  def top_three_elves(elves) do
    elves
    |> Enum.map(&Enum.sum(&1))
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.sum
  end
end
