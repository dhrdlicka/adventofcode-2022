defmodule AdventOfCode.Day12 do
  @doc ~S"""
  Parses the given `input` into a two-dimensional map.

  ### Examples

      iex> File.read!("test/day12/input1.txt") |> Day12.parse
      ['Sabqponm',
       'abcryxxl',
       'accszExk',
       'acctuvwj',
       'abdefghi']
  """
  def parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_charlist/1)
  end

  defp consider_nodes(_, [], distances, _), do: distances
  defp consider_nodes(node, [head | tail], distances, fun) do
    if fun.(node, head) and distances[node] + 1 < Map.get(distances, head, :infinity) do
      consider_nodes(node, tail, Map.put(distances, head, distances[node] + 1), fun)
    else
      consider_nodes(node, tail, distances, fun)
    end
  end

  defp neighboring_nodes({x, y}), do: [{x - 1, y}, {x + 1, y}, {x, y - 1}, {x, y + 1}]

  defp visit_node(node, unvisited_nodes, distances, can_move?, is_end?) do
    neighbors = unvisited_nodes -- (unvisited_nodes -- neighboring_nodes(node))
    distances = consider_nodes(node, neighbors, distances, can_move?)

    unvisited_nodes = unvisited_nodes -- [node]
    next_node = Enum.min_by(unvisited_nodes, &Map.get(distances, &1, :infinity))

    cond do
      distances[next_node] == :infinity -> nil
      is_end?.(next_node) -> distances[next_node]
      true -> visit_node(next_node, unvisited_nodes, distances, can_move?, is_end?)
    end
  end

  defp get(map, {x, y}) do
    map |> Enum.at(y) |> Enum.at(x)
  end

  defp find([row | tail], char, y \\ 0) do
    find_vert = fn
      [^char | _], x, _ -> x
      [_ | tail], x, recur -> recur.(tail, x + 1, recur)
      [], _, _ -> nil
    end

    case find_vert.(row, 0, find_vert) do
      nil -> find(tail, char, y + 1)
      x -> {x, y}
    end
  end

  defp shortest_path(map, start, ends, can_move?) do
    unvisited_nodes = for y <- 0..length(map) - 1, x <- 0..length(List.first(map)) - 1 do
      {x, y}
    end

    node = find(map, start)
    visit_node(node, unvisited_nodes, %{node => 0}, can_move?, &(get(map, &1) in ends))
  end

  defp can_move?(map, a, b) do
    {a, b} = case {get(map, a), get(map, b)} do
      {?S, ?E} -> {?a, ?b}
      {?S, b} -> {?a, b}
      {a, ?E} -> {a, ?z}
      {a, b} -> {a, b}
    end

    cond do
      a >= b -> true
      a + 1 == b -> true
      true -> false
    end
  end

  @doc ~S"""
  Returns the length of the shortest possible route from point S to point E.

  ### Examples

      iex> File.read!("test/day12/input1.txt") |> Day12.parse |> Day12.from_start
      31

      iex> File.read!("test/day12/input2.txt") |> Day12.parse |> Day12.from_start
      440
  """
  def from_start(map) do
    shortest_path(map, ?S, [?E], &can_move?(map, &1, &2))
  end

  @doc ~S"""
  Returns the length of the shortest possible route from any point at level `a`
  (including point S) to point E.

  ### Examples

      iex> File.read!("test/day12/input1.txt") |> Day12.parse |> Day12.from_level_a
      29

      iex> File.read!("test/day12/input2.txt") |> Day12.parse |> Day12.from_level_a
      439
  """
  def from_level_a(map) do
    shortest_path(map, ?E, [?S, ?a], &can_move?(map, &2, &1))
  end
end
