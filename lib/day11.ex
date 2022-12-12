defmodule AdventOfCode.Day11 do
  defp parse_monkey(input) do
    [_, number, items, operation, operand, divisor, if_true, if_false] =
      Regex.run(~r/(\d+).[\s\S]+?(\d+(?:, \d+)*)[\s\S]+?([*+]) (old|\d+)[\s\S]+?(\d+)[\s\S]+?(\d+)[\s\S]+?(\d+)/, input)

      items = String.split(items, ", ") |> Enum.map(&String.to_integer/1)
      operation = case {operation, operand} do
        {"*", "old"} -> &(&1 * &1)
        {"*", x} -> &(&1 * String.to_integer(x))
        {"+", x} -> &(&1 + String.to_integer(x))
      end

    {%{number: String.to_integer(number), operation: operation,
       divisor: String.to_integer(divisor), true: String.to_integer(if_true),
       false: String.to_integer(if_false)}, items}
  end

  @doc ~S"""
  Parses the given `input` into a tuple consisting of a list of monkeys and
  a list of the worry levels of the items they start out with.

  ### Examples

      iex> {_, items} = File.read!("test/day11/input1.txt") |> Day11.parse
      iex> items
      [
        [79, 98],
        [54, 65, 75, 74],
        [79, 60, 97],
        [74]
      ]
  """
  def parse(input) do
    input
    |> String.split("\n\n", trim: true)
    |> Enum.map(&parse_monkey/1)
    |> Enum.unzip
  end

  defp inspect_items(_, [], thrown_items, _) do
    thrown_items
    |> Enum.map(&Enum.reverse/1)
  end

  defp inspect_items(%{operation: op, divisor: divisor} = monkey, [head | tail], thrown_items, fun) do
    head = head |> op.() |> fun.()
    next = if rem(head, divisor) == 0 do monkey[true] else monkey[false] end
    thrown_items = List.replace_at(thrown_items, next, [head | Enum.at(thrown_items, next)])
    inspect_items(monkey, tail, thrown_items, fun)
  end

  defp do_round({monkeys, items}, fun) do
    Enum.reduce(monkeys, {[], items}, fn %{number: number} = monkey, {counters, items} ->
      inspected_items = Enum.at(items, number)
      thrown_items = inspect_items(monkey, inspected_items, List.duplicate([], length(monkeys)), fun)

      items = List.replace_at(items, number, []) |> Enum.zip_with(thrown_items, &Kernel.++/2)

      {[length(inspected_items) | counters], items}
    end)
  end

  defp monkey_business(range, {monkeys, items}, fun) do
    range
    |> Enum.map_reduce(items, fn _, items -> do_round({monkeys, items}, fun) end)
    |> elem(0)
    |> Enum.zip_with(&Enum.sum/1)
    |> Enum.sort(:desc)
    |> Enum.take(2)
    |> Enum.reduce(&Kernel.*/2)
  end

  @doc ~S"""
  Calculates the monkey business level after twenty rounds, assuming that after
  each item is inspected, the worry level is divided by 3.

  ### Examples

      iex> File.read!("test/day11/input1.txt") |> Day11.parse |> Day11.part_one
      10605

      iex> File.read!("test/day11/input2.txt") |> Day11.parse |> Day11.part_one
      99852
  """
  def part_one(input), do: monkey_business(1..20, input, &(div(&1, 3)))

  @doc ~S"""
  Calculates the monkey business level after twenty rounds, assuming that the
  worry level does not decrease upon each item being inspected.

  ### Examples

      iex> File.read!("test/day11/input1.txt") |> Day11.parse |> Day11.part_two
      2713310158

      iex> File.read!("test/day11/input2.txt") |> Day11.parse |> Day11.part_two
      25935263541
  """
  def part_two({monkeys, _} = input) do
    factor = Enum.reduce(monkeys, 1, &(&1[:divisor] * &2))
    monkey_business(1..10000, input, &(rem(&1, factor)))
  end
end
