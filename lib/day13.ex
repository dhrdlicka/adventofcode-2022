defmodule AdventOfCode.Day13 do
  @doc ~S"""
  Parses the `input` packets.

  ### Examples

      iex> File.read!("test/day13/input1.txt") |> Day13.parse
      [
        [1, 1, 3, 1, 1],
        [1, 1, 5, 1, 1],
        [[1], [2, 3, 4]],
        [[1], 4],
        '\t',
        [[8, 7, 6]],
        [[4, 4], 4, 4],
        [[4, 4], 4, 4, 4],
        '\a\a\a\a',
        '\a\a\a',
        [],
        [3],
        [[[]]],
        [[]],
        [1, [2, [3, [4, [5, 6, 7]]]], 8, 9],
        [1, [2, [3, [4, [5, 6, 0]]]], 8, 9]
      ]
  """
  def parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&Code.string_to_quoted!/1)
  end

  defp compare(left, right) when is_integer(left) and is_integer(right) do
    cond do
      left < right -> :lt
      left == right -> :eq
      left > right -> :gt
    end
  end

  defp compare([left | left_tail], [right | right_tail]) do
    case compare(left, right) do
      :eq -> compare(left_tail, right_tail)
      result -> result
    end
  end

  defp compare([], [_ | _]), do: :lt
  defp compare([_ | _], []), do: :gt
  defp compare([], []), do: :eq

  defp compare(left, right) when is_integer(left) do
    compare([left], right)
  end

  defp compare(left, right) when is_integer(right) do
    compare(left, [right])
  end

  @doc ~S"""
  Verifies that each pair of packets is in the right order, and returns the sum
  of indices of valid pairs.

  ### Examples

      iex> File.read!("test/day13/input1.txt") |> Day13.parse |> Day13.verify_pairs
      13

      iex> File.read!("test/day13/input2.txt") |> Day13.parse |> Day13.verify_pairs
      6369
  """
  def verify_pairs(packets) do
    packets
    |> Enum.chunk_every(2)
    |> Enum.with_index(1)
    |> Enum.reduce(0, fn {[left, right], i}, acc ->
         if compare(left, right) == :lt, do: acc + i, else: acc
       end)
  end

  @doc ~S"""
  Determines the decoder key for the given `packets`. The decoder key is
  calculated by multiplying the positions of divider packets within a sorted
  list of packets.

  ### Examples

      iex> File.read!("test/day13/input1.txt") |> Day13.parse |> Day13.decoder_key
      140

      iex> File.read!("test/day13/input2.txt") |> Day13.parse |> Day13.decoder_key
      25800
  """
  def decoder_key(packets) do
    divider_packets = [[[2]], [[6]]]

    divider_packets ++ packets
    |> Enum.sort(&(compare(&1, &2) == :lt))
    |> Enum.with_index(1)
    |> Enum.reduce(1, fn {packet, i}, acc ->
         if packet in divider_packets, do: acc * i, else: acc
       end)
  end
end
