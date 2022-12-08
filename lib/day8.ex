defmodule AdventOfCode.Day8 do
  @doc ~S"""
  Parses the `input` string into a list of character lists.

  ### Examples

      iex> File.read!("test/day8/input1.txt") |> Day8.parse
      ['30373', '25512', '65332', '33549', '35390']
  """
  def parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_charlist(&1))
  end

  defp rotate(matrix, 0), do: matrix
  defp rotate(matrix, 90), do: Enum.zip_with(matrix, &Enum.reverse(&1))
  defp rotate(matrix, 180), do: Enum.reverse(Enum.map(matrix, &Enum.reverse(&1)))
  defp rotate(matrix, 270), do: Enum.reverse(Enum.zip_with(matrix, &(&1)))
  defp rotate(matrix, 360), do: matrix

  defp all_directions_transform(matrix, fun) do
    {matrices, _} =
      Enum.map_reduce(0..270//90, matrix, fn i, matrix ->
        {fun.(matrix) |> rotate(360 - i), rotate(matrix, 90)}
      end)

    matrices
  end

  defp final_transform(matrices, fun) do
    Enum.zip_with(matrices, &Enum.zip_with(&1, fn [w, x, y, z] -> fun.(w, x, y, z) end))
  end

  @doc ~S"""
  Calculates the total number of trees visible from the area's edges.

  ### Examples

      iex> File.read!("test/day8/input1.txt") |> Day8.parse |> Day8.visible_trees
      21

      iex> File.read!("test/day8/input2.txt") |> Day8.parse |> Day8.visible_trees
      1803
  """
  def visible_trees(matrix) do
    matrix
    |> all_directions_transform(&directional_visibility/1)
    |> final_transform(&(&1 or &2 or &3 or &4))
    |> Enum.map(fn row -> Enum.count(row, &(&1)) end)
    |> Enum.sum
  end

  defp directional_visibility(matrix) do
    {matrix, _} =
      Enum.map_reduce(matrix, List.duplicate(0, length(List.first(matrix))), fn row, acc ->
        {Enum.zip_with([row, acc], fn [height, max] -> height > max end),
         Enum.zip_with([row, acc], fn [height, max] -> max(height, max) end)}
      end)
    matrix
  end

  @doc ~S"""
  Calculates the maximum scenic score achievable in the given area. Scenic score
  is calculated as distance to the nearest tree of same or higher height in each
  direction, multiplied by each other.

  ### Examples

      iex> File.read!("test/day8/input1.txt") |> Day8.parse |> Day8.top_scenic_score
      8

      iex> File.read!("test/day8/input2.txt") |> Day8.parse |> Day8.top_scenic_score
      268912
  """
  def top_scenic_score(matrix) do
    matrix
    |> all_directions_transform(&directional_scenic_score/1)
    |> final_transform(&(&1 * &2 * &3 * &4))
    |> Enum.map(&Enum.max(&1))
    |> Enum.max
  end

  defp directional_scenic_score(matrix) do
    Enum.map(matrix, fn row ->
      {row, _} =
        Enum.map_reduce(row, List.duplicate(0, 10), fn height, distances ->
          {Enum.at(distances, height - ?0),
          for i <- ?0..?9 do if i <= height do 1 else Enum.at(distances, i - ?0) + 1 end end}
        end)
      row
    end)
  end
end
