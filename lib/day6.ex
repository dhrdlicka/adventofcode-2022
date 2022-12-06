defmodule AdventOfCode.Day6 do
  defp find_marker(message, len), do: find_marker(message, len, len)
  defp find_marker(message, len, i) do
    case message |> Enum.take(len) |> Enum.uniq |> Enum.count do
      ^len -> i
      _ -> find_marker(Enum.drop(message, 1), len, i + 1)
    end
  end

  @doc ~s"""
  Finds the first packet marker (four distinct characters) in the `input` string

  ### Examples

      iex> Day6.first_packet_marker("mjqjpqmgbljsphdztnvjfqwrcgsmlb")
      7

      iex> Day6.first_packet_marker("bvwbjplbgvbhsrlpgdmjqwftvncz")
      5

      iex> Day6.first_packet_marker("nppdvjthqldpwncqszvftbrmjlhg")
      6

      iex> Day6.first_packet_marker("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg")
      10

      iex> Day6.first_packet_marker("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw")
      11

      iex> File.read!("test/day6/input.txt") |> Day6.first_packet_marker
      1876
  """
  def first_packet_marker(input) do
    input
    |> String.to_charlist
    |> find_marker(4)
  end

  @doc ~s"""
  Finds the first message marker (14 distinct characters) in the `input` string

  ### Examples

      iex> Day6.first_message_marker("mjqjpqmgbljsphdztnvjfqwrcgsmlb")
      19

      iex> Day6.first_message_marker("bvwbjplbgvbhsrlpgdmjqwftvncz")
      23

      iex> Day6.first_message_marker("nppdvjthqldpwncqszvftbrmjlhg")
      23

      iex> Day6.first_message_marker("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg")
      29

      iex> Day6.first_message_marker("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw")
      26

      iex> File.read!("test/day6/input.txt") |> Day6.first_message_marker
      2202
  """
  def first_message_marker(input) do
    input
    |> String.to_charlist
    |> find_marker(14)
  end
end
