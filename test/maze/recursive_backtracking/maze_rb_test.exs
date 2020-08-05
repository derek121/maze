defmodule Maze.RecursiveBacktracking.MazeRBTest do
  use ExUnit.Case

  alias Maze.Common
  alias Maze.RecursiveBacktracking.MazeRB, as: Maze

  test "set_open" do
    actual =
      create_3x3_grid()
      |> Common.set_open({1,1}, :n)
      |> Common.set_open({1,1}, :e)

    expected =
      create_3x3_grid()
      |> Map.put({1,1}, MapSet.new([:n, :e]))

    assert actual == expected
  end

  test "can_visit? true" do
    grid = create_3x3_grid()

    assert Maze.can_visit?({0,0}, grid) == true
    assert Maze.can_visit?({1,1}, grid) == true
  end

  test "can_visit? false" do
    grid =
      create_3x3_grid()
      |> Common.set_open({1,1}, :n)
      |> Common.set_open({1,1}, :e)

    assert Maze.can_visit?({1,1}, grid) == false
    assert Maze.can_visit?({9,9}, grid) == false
  end

  test "carve_passages_from" do
    # Create a dummy/bogus 3x3 grid with all except the center ({1,1}) and the one below
    # the center ({2,1}) are marked as open to :e
    start_grid =
      create_3x3_grid()
      |> Common.set_open({0,0}, :e)
      |> Common.set_open({1,0}, :e)
      |> Common.set_open({2,0}, :e)
      |> Common.set_open({0,1}, :e)
      |> Common.set_open({0,2}, :e)
      |> Common.set_open({1,2}, :e)
      |> Common.set_open({2,2}, :e)

    # Starting at center ({1,1}), expect it open to :s and below it open to :n

    expected_grid =
      start_grid
      |> Common.set_open({1,1}, :s)
      |> Common.set_open({2,1}, :n)

    actual_grid = Maze.carve_passages_from(start_grid, {1,1})

    assert actual_grid == expected_grid
  end

  # Not actually a test
  test "carve_passages_from, clean" do
    start_grid = create_3x3_grid()

    _actual_grid = Maze.carve_passages_from(start_grid, {0,0})
  end

  test "validate_grid good" do
    start_grid = create_3x3_grid()
    grid = Maze.carve_passages_from(start_grid, {0,0})

    assert Maze.validate_grid(grid) == true
  end

  test "validate_grid bad" do
    start_grid = create_3x3_grid()
    grid = Maze.carve_passages_from(start_grid, {0,0})

    # Clear all open sides from {1,1}
    grid = %{grid | {1, 1} => MapSet.new()}

    assert Maze.validate_grid(grid) == false
  end

  ###

  defp create_3x3_grid() do
    Common.create_grid(3, 3)
  end

end

