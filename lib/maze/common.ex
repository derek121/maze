defmodule Maze.Common do

  def create_grid(h, w) do
    # Step results:
    # [ {0, 0}, {0, 1}, {0, 2}, ... ]
    # [ {{0, 0}, #MapSet<[]>}, {{0, 1}, #MapSet<[]>}, {{0, 2}, #MapSet<[]>}, ... ]
    # %{ {0, 0} => #MapSet<[]>, {0, 1} => #MapSet<[]>, {0, 2} => #MapSet<[]>, ... }

    (for x <- Enum.to_list(0..h-1), y <- Enum.to_list(0..w-1), do: {x, y})
    |> Enum.zip(Stream.cycle([MapSet.new()]))
    |> Map.new()
  end

  def set_open(grid, coords, direction), do: Map.update!(grid, coords, &MapSet.put(&1, direction))

end

