defmodule Maze.CommonTest do
  use ExUnit.Case

  alias Maze.Common

  test "create_grid" do
    actual = Common.create_grid(3, 3)

    expected =
      %{
        {0, 0} => MapSet.new(),
        {0, 1} => MapSet.new(),
        {0, 2} => MapSet.new(),
        {1, 0} => MapSet.new(),
        {1, 1} => MapSet.new(),
        {1, 2} => MapSet.new(),
        {2, 0} => MapSet.new(),
        {2, 1} => MapSet.new(),
        {2, 2} => MapSet.new() }

    assert actual == expected
  end


end

