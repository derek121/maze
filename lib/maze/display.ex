defmodule Maze.Display do

  def format(grid) do
    h = (grid |> Map.keys() |> Enum.map(&elem(&1, 0)) |> Enum.max()) + 1
    w = (grid |> Map.keys() |> Enum.map(&elem(&1, 1)) |> Enum.max()) + 1

    # ┌┬┬┐
    # ┝┿┿┥
    # ┝┿┿┥
    # └┴┴┘

    create_start(h, w)
    |> process_grid(grid)
    |> format_display()
  end

  def format_display(disp) do
    disp_w = (disp |> Map.keys() |> Enum.map(&elem(&1, 1)) |> Enum.max()) + 1

    disp
    |> Enum.sort()
    |> Enum.map(&elem(&1, 1))
    |> Enum.map(&convert_to_img/1)
    |> Enum.chunk_every(disp_w)
    |> Enum.map(&Enum.join/1)
    |> Enum.join("\n")
  end

  def create_start(h, w) do
    # Step results:
    # [ {0, 0}, {0, 1}, {0, 2}, ... ]
    # [ {{0, 0}, [:hr, :vd]}, {{0, 1}, [:hl, :hr, :vd]}, {{0, 2}, [:hl, :hr, :vd]}, {{0, 3}, [:hl, :vd]}, ... ]
    # %{ {0, 0} => [:hr, :vd], {0, 1} => [:hl, :hr, :vd], {0, 2} => [:hl, :hr, :vd], {0, 3} => [:hl, :vd], ... }

    # Each dimension is one greater than the height or width (since 0 to the dimension, inclusive)
    (for x <- Enum.to_list(0..h), y <- Enum.to_list(0..w), do: {x, y})
    |> Enum.map(&set_start_lines(&1, h, w))
    |> Map.new()
  end

  ###
  # In:
  # disp: the return from create_start()
  # grid: as returned from both Maze.create_grid() and Maze.carve_passages_from()
  #       Assumes that doors/openings are mutual- e.g., a cell open to the east has a cell to the east,
  #       and that cell has opening to the west
  # Out: The input disp with walls opened according to grid
  #
  def process_grid(disp, grid) do
    # grid such as:
    # %{
    #   {0, 0} => #MapSet<[:s, :e]>,
    #   ...
    # }

    Enum.reduce(grid, disp, fn({grid_coords, directions}, disp_acc) ->
      open_walls(disp_acc, grid_coords, directions)
    end)
  end

  def open_walls(disp, grid_coords, directions) do
    Enum.reduce(MapSet.to_list(directions), disp, fn(dir, disp_acc) ->
      open_wall(disp_acc, grid_coords, dir)
    end)
  end

  ###
  # ┌┬┬┐
  # ┝┿┿┥
  # ┝┿┿┥
  # └┴┴┘
  def open_wall(disp, grid_coords, :e) do
    {grid_x, grid_y} = grid_coords

    # Remove any :vd from above or :vu from below
    disp_above_coords = {grid_x,     grid_y + 1}
    disp_below_coords = {grid_x + 1, grid_y + 1}

    disp
    |> remove_line(disp_above_coords, :vd)
    |> remove_line(disp_below_coords, :vu)
  end

  def open_wall(disp, grid_coords, :s) do
    {grid_x, grid_y} = grid_coords

    # Remove any :hr from left or :hl from right
    disp_left_coords  = {grid_x + 1, grid_y}
    disp_right_coords = {grid_x + 1, grid_y + 1}

    disp
    |> remove_line(disp_left_coords,  :hr)
    |> remove_line(disp_right_coords, :hl)
  end

  def open_wall(disp, _grid_coords, _dir) do
    #IO.puts("Unimplemented open_wall for grid_coords: #{inspect(grid_coords)}. dir: #{inspect(dir)}")
    disp
  end

  def remove_line(disp, disp_coords, dir) do
    Map.update!(disp, disp_coords, fn lines -> List.delete(lines, dir) end)
  end

  defp convert_to_img([:hr, :vd]),           do: "\u250c" # ┌
  defp convert_to_img([:hl, :vd]),           do: "\u2510" # ┐
  defp convert_to_img([:hr, :vu]),           do: "\u2514" # └
  defp convert_to_img([:hl, :vu]),           do: "\u2518" # ┘
  defp convert_to_img([:hl, :hr, :vd]),      do: "\u252c" # ┬
  defp convert_to_img([:hl, :hr, :vu]),      do: "\u2534" # ┴
  defp convert_to_img([:hr, :vd, :vu]),      do: "\u251d" # ┝
  defp convert_to_img([:hl, :vd, :vu]),      do: "\u2525" # ┥
  defp convert_to_img([:hl, :hr, :vd, :vu]), do: "\u253f" # ┿

  defp convert_to_img([:hl, :hr]),           do: "\u2500" # ─
  defp convert_to_img([:vd, :vu]),           do: "\u2502" # │

  defp convert_to_img([:vd]),                do: "\u2577" # ╷
  defp convert_to_img([:vu]),                do: "\u2575" # ╵

  defp convert_to_img([:hl]),                do: "\u2574" # ╴
  defp convert_to_img([:hr]),                do: "\u2576" # ╶

  defp convert_to_img([]),                   do: " "      # (space)

  ###
  # Corners
  # The atom lists in the returned tuples must be sorted in order to pattern match
  #   the convert_to_img() function heads
  defp set_start_lines({x, y} = disp_coords, _h, _w)  when x == 0 and y == 0, do: {disp_coords, [:hr, :vd]}
  defp set_start_lines({x, y} = disp_coords, _h, w)   when x == 0 and y == w, do: {disp_coords, [:hl, :vd]}
  defp set_start_lines({x, y} = disp_coords, h, _w)   when x == h and y == 0, do: {disp_coords, [:hr, :vu]}
  defp set_start_lines({x, y} = disp_coords, h, w)    when x == h and y == w, do: {disp_coords, [:hl, :vu]}
  # Top, bottom
  defp set_start_lines({x, _y} = disp_coords, _h, _w) when x == 0,            do: {disp_coords, [:hl, :hr, :vd]}
  defp set_start_lines({x, _y} = disp_coords, h, _w)  when x == h,            do: {disp_coords, [:hl, :hr, :vu]}
  # Left, right
  defp set_start_lines({_x, y} = disp_coords, _h, _w) when y == 0,            do: {disp_coords, [:hr, :vd, :vu]}
  defp set_start_lines({_x, y} = disp_coords, _h, w)  when y == w,            do: {disp_coords, [:hl, :vd, :vu]}
  # Internal
  defp set_start_lines({_x, _y} = disp_coords, _h, _w),                       do: {disp_coords, [:hl, :hr, :vd, :vu]}

end

