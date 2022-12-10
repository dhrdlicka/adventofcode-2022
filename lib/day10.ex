defmodule AdventOfCode.Day10 do
  @doc ~S"""
  Parses the given `input` instructions, executes them and returns a list of
  values of the X register in each cycle of execution.

  ### Examples

      iex> File.read!("test/day10/input1.txt") |> Day10.execute
      [1, 1, 1, 4, 4, -1]
  """
  def execute(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.reduce([1], fn instruction, [x | tail] ->
      case Regex.run(~r/(\w+)(?: (-?\d*))?/, instruction) do
        [_, "addx", operand] -> [x + String.to_integer(operand), x, x | tail]
        [_, "noop"] -> [x, x | tail]
      end
    end)
    |> Enum.reverse
  end

  @doc ~S"""
  Returns the sum of signal strengths on the 20th, 60th, 100th, 140th, 180th and
  220th cycles. Signal strength is a factor of the cycle number and the value
  of the X register on that cycle.

  ### Examples

      iex> File.read!("test/day10/input2.txt") |> Day10.execute |> Day10.signal_strength_sum
      13140

      iex> File.read!("test/day10/input3.txt") |> Day10.execute |> Day10.signal_strength_sum
      12520
  """
  def signal_strength_sum(cycles) do
    [20, 60, 100, 140, 180, 220]
    |> Enum.reduce(0, fn cycle, acc -> Enum.at(cycles, cycle - 1) * cycle + acc end)
  end

  @doc ~S"""
  Simulates the output of a CRT screen that renders a pixel on each cycle and
  that is being fed the values of the X register, assuming that the register
  sets the horizontal position of a 3px wide sprite.

  ### Examples

      iex> File.read!("test/day10/input2.txt") |> Day10.execute |> Day10.crt_render
      ['##..##..##..##..##..##..##..##..##..##..',
       '###...###...###...###...###...###...###.',
       '####....####....####....####....####....',
       '#####.....#####.....#####.....#####.....',
       '######......######......######......####',
       '#######.......#######.......#######.....']

      iex> File.read!("test/day10/input3.txt") |> Day10.execute |> Day10.crt_render
      ['####.#..#.###..####.###....##..##..#....',
       '#....#..#.#..#....#.#..#....#.#..#.#....',
       '###..####.#..#...#..#..#....#.#....#....',
       '#....#..#.###...#...###.....#.#.##.#....',
       '#....#..#.#....#....#....#..#.#..#.#....',
       '####.#..#.#....####.#.....##...###.####.']
  """
  def crt_render(cycles) do
    for y <- 0..5, x <- 0..39 do
      rx = Enum.at(cycles, y * 40 + x)
      if rx == x or rx == x - 1 or rx == x + 1 do ?# else ?. end
    end
    |> Enum.chunk_every(40)
  end
end
