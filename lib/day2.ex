defmodule AdventOfCode.Day2 do

  defp parse_move("A"), do: :rock
  defp parse_move("B"), do: :paper
  defp parse_move("C"), do: :scissors

  defp parse_move("X"), do: :x
  defp parse_move("Y"), do: :y
  defp parse_move("Z"), do: :z

  @doc ~S"""
  Parses the given `input`

  ### Examples

      iex> File.read!("test/day2/input1.txt") |> Day2.parse
      [{:rock, :y}, {:paper, :x}, {:scissors, :z}]
  """
  def parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn turn ->
      turn
      |> String.split(" ", trim: true)
      |> Enum.map(&parse_move(&1))
      |> List.to_tuple()
    end)
  end

  defp outcome({:rock, :rock}), do: :draw
  defp outcome({:paper, :paper}), do: :draw
  defp outcome({:scissors, :scissors}), do: :draw

  defp outcome({:rock, :paper}), do: :win
  defp outcome({:paper, :scissors}), do: :win
  defp outcome({:scissors, :rock}), do: :win

  defp outcome({:rock, :scissors}), do: :loss
  defp outcome({:paper, :rock}), do: :loss
  defp outcome({:scissors, :paper}), do: :loss

  defp score({_, player_move} = turn) do
    outcome_score =
      case outcome(turn) do
        :win -> 6
        :draw -> 3
        :loss -> 0
      end

    shape_score =
      case player_move do
        :rock -> 1
        :paper -> 2
        :scissors -> 3
      end

    outcome_score + shape_score
  end

  @doc ~S"""
  Calculates the player score from the given `moves`, assuming that they consist
  of shapes chosen by both the opponent and player.

  ### Examples

      iex> File.read!("test/day2/input1.txt") |> Day2.parse |> Day2.part_one
      15

      iex> File.read!("test/day2/input2.txt") |> Day2.parse |> Day2.part_one
      9177
  """
  def part_one(moves) do
    moves
    |> Enum.map(fn
      {opponent_move, :x} -> {opponent_move, :rock}
      {opponent_move, :y} -> {opponent_move, :paper}
      {opponent_move, :z} -> {opponent_move, :scissors}
    end)
    |> Enum.reduce(0, &(&2 + score(&1)))
  end

  defp determine_move(:rock, :draw), do: :rock
  defp determine_move(:paper, :draw), do: :paper
  defp determine_move(:scissors, :draw), do: :scissors

  defp determine_move(:rock, :win), do: :paper
  defp determine_move(:paper, :win), do: :scissors
  defp determine_move(:scissors, :win), do: :rock

  defp determine_move(:rock, :loss), do: :scissors
  defp determine_move(:paper, :loss), do: :rock
  defp determine_move(:scissors, :loss), do: :paper

  @doc ~S"""
  Calculates the player score from the given `moves`, assuming that they consist
  of the opponent's moves and the desired result.

  ### Examples

      iex> File.read!("test/day2/input1.txt") |> Day2.parse |> Day2.part_two
      12

      iex> File.read!("test/day2/input2.txt") |> Day2.parse |> Day2.part_two
      12111
  """
  def part_two(moves) do
    moves
    |> Enum.map(fn
      {opponent_move, :x} -> {opponent_move, determine_move(opponent_move, :loss)}
      {opponent_move, :y} -> {opponent_move, determine_move(opponent_move, :draw)}
      {opponent_move, :z} -> {opponent_move, determine_move(opponent_move, :win)}
    end)
    |> Enum.reduce(0, &(&2 + score(&1)))
  end
end
