defmodule Maze.RecursiveBacktracking.MazeRB do
  alias Maze.Common

  @moduledoc """
  Create a maze using a recursive backtracking algorithm. Inspired by
  http://weblog.jamisbuck.org/2010/12/27/maze-generation-recursive-backtracking

  Overview of the algorithm, from that page:
  * Choose a starting point in the field.
  * Randomly choose a wall at that point and carve a passage through to the
    adjacent cell, but only if the adjacent cell has not been visited yet.
    This becomes the new current cell.
  * If all adjacent cells have been visited, back up to the last cell that
    has uncarved walls and repeat.
  * The algorithm ends when the process has backed all the way up to the starting point.
  """


  @doc """
  Carve a maze.

  In:
  grid: the grid in question, of the format as returned from `Common/create_grid/2`
  cur_coords: coordinates to carve from (e.g., `{0, 0}`

  Out:
  The incoming grid with passages carved.

  %{
  {0, 0} => #MapSet<[]>,
  {0, 1} => #MapSet<[]>,
  {0, 2} => #MapSet<[]>,
  {1, 0} => #MapSet<[]>,
  {1, 1} => #MapSet<[]>,
  {1, 2} => #MapSet<[]>,
  {2, 0} => #MapSet<[]>,
  {2, 1} => #MapSet<[]>,
  {2, 2} => #MapSet<[]>
  }

  Example:

  Output will be a random maze such as (with display niceness depending on the font/terminal):
  ┌┬───┐
  │└┐╶┐│
  ┝┐└┬┘│
  │└┐│╶┥
  │╷╵└╴│
  └┴───┘

  iex> grid = Common.create_grid(5, 5)
  iex> carved = MazeRB.carve_passages_from(grid, {0,0})
  iex> _formatted = Maze.Display.format(carved)
  iex> #IO.puts(_formatted)
  """
  def carve_passages_from(grid, cur_coords) do
    List.foldl(rand_directions(), grid, fn(direction, acc_grid) ->
      carve_passages_to(direction, cur_coords, acc_grid) end)
  end

  defp carve_passages_to(direction, {cx, cy} = cur_coords, grid) do
    new_coords = {cx + dx(direction), cy + dy(direction)}

    if can_visit?(new_coords, grid) do
      grid
      |> Common.set_open(cur_coords, direction)
      |> Common.set_open(new_coords, inv(direction))
      |> carve_passages_from(new_coords)

    else
      grid
    end
  end

  # Valid if within bounds and has not been visited (i.e., val is 0 (not nil (off the grid) or >0))
  def can_visit?(coords, grid) do
    case Map.get(grid, coords) do
      nil -> false
      elem -> MapSet.size(elem) == 0
    end
  end

  defp dx(:n), do: -1
  defp dx(:s), do: 1
  defp dx(:e), do: 0
  defp dx(:w), do: 0

  defp dy(:n), do: 0
  defp dy(:s), do: 0
  defp dy(:e), do: 1
  defp dy(:w), do: -1

  defp inv(:n), do: :s
  defp inv(:s), do: :n
  defp inv(:e), do: :w
  defp inv(:w), do: :e

  defp rand_directions(), do: Enum.shuffle([:n, :s, :e, :w])

  ###
  # For dev:

  def validate_grid(grid) do
    grid
    |> Enum.reduce(true, fn cell, acc ->
      acc && validate_cell(grid, cell)
    end)
  end

  defp validate_cell(grid, {coords, directions}) do
    directions
    |> Enum.reduce(true, fn dir, acc ->
      validate_cell_direction(grid, coords, dir) && acc
    end)
  end

  defp validate_cell_direction(grid, coords, dir) do
    other = compute_other_coords(coords, dir)
    validate_other_direction(grid, other, inv(dir))
  end

  defp compute_other_coords({x, y}, :n), do: {x - 1, y}
  defp compute_other_coords({x, y}, :s), do: {x + 1, y}
  defp compute_other_coords({x, y}, :e), do: {x, y + 1}
  defp compute_other_coords({x, y}, :w), do: {x, y - 1}

  defp validate_other_direction(grid, other, dir) do
    with(
      directions when directions != nil <- Map.get(grid, other, nil),
      true <- MapSet.member?(directions, dir)
    ) do
      true
    else
      nil ->
        false
      false ->
        # Should be open in direction dir
        false
    end
  end

  def print_grid(grid) do
    w = (grid |> Map.keys() |> Enum.map(&elem(&1, 1)) |> Enum.max()) + 1

    grid
    |> Enum.sort()
    |> Enum.map(&elem(&1, 1))
    |> Enum.map(&MapSet.to_list(&1))
    |> Enum.map(&Enum.map(&1, fn(d) -> dir_to_symbol(d) end))
    |> Enum.chunk_every(w)
    |> Enum.map(&Enum.join(&1, " "))
    |> Enum.each(&IO.inspect(&1))
  end

  defp dir_to_symbol(:n), do: "\u2191"
  defp dir_to_symbol(:s), do: "\u2193"
  defp dir_to_symbol(:e), do: "\u2192"
  defp dir_to_symbol(:w), do: "\u2190"

end

