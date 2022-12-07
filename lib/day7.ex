defmodule AdventOfCode.Day7 do
  @doc ~S"""
  Parses the given `input` into a map of directories and occupied space.

  ### Examples

      iex> File.read!("test/day7/input1.txt") |> Day7.parse
      {48381165, %{"/" => 48381165, "/a/" => 94853, "/a/e/" => 584, "/d/" => 24933642}}
  """
  def parse(input) do
    {sizes, paths, map} =
      input
      |> String.split("\n", trim: true)
      |> Enum.reduce(nil, fn
        "$ cd /", nil -> {[0], ["/"], %{}}
        line, {[size_head | size_tail] = sizes, [path_head | path_tail] = paths, map} = acc ->
          case Regex.run(~r/(?:\$ )?(\S*)(?: ?(\S*))?/, line) do
            [_, "ls", _] -> acc
            [_, "dir", _] -> acc
            [_, "cd", ".."] ->
              [size_second | size_tail] = size_tail
              {[size_head + size_second | size_tail], path_tail, Map.put(map, path_head, size_head)}
            [_, "cd", name] -> {[0 | sizes], ["#{path_head}#{name}/" | paths], map}
            [_, size, _] -> {[size_head + String.to_integer(size) | size_tail], paths, map}
          end
      end)

    Enum.zip_reduce([sizes, paths], {0, map}, fn [size, path], {total_size, map} ->
      {total_size + size, Map.put(map, path, total_size + size)}
    end)
  end

  @doc ~S"""
  Calculates the sum of the sizes of all directories with a total size of
  at most 100K.

  ### Examples

      iex> File.read!("test/day7/input1.txt") |> Day7.parse |> Day7.part_one
      95437

      iex> File.read!("test/day7/input2.txt") |> Day7.parse |> Day7.part_one
      1490523
  """
  def part_one({_, map}) do
    map
    |> Map.values
    |> Enum.reject(fn x -> x > 100000 end)
    |> Enum.sum
  end

  @doc ~S"""
  Determines the size of the smallest directory that could be deleted in order
  to make space for the 30M update.

  ### Examples

      iex> File.read!("test/day7/input1.txt") |> Day7.parse |> Day7.part_two
      24933642

      iex> File.read!("test/day7/input2.txt") |> Day7.parse |> Day7.part_two
      12390492
  """
  def part_two({size, map}) do
    map
    |> Map.values
    |> Enum.reject(fn x -> x < 30000000 - (70000000 - size) end)
    |> Enum.min
  end
end
