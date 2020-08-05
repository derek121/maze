defmodule Maze.DisplayTest do
  use ExUnit.Case

  alias Maze.Common
  alias Maze.Display

  # Not actually a test- just for visually checking
  test "process_grid() :e top and bottom rows" do
#    IO.puts("\nprocess_grid() :e top and bottom")

#    %{
#      {0, 0} => MapSet.new([:e]),
#      {0, 1} => MapSet.new([:e]),
#      {2, 0} => MapSet.new([:e]),
#      {2, 1} => MapSet.new([:e])
#    }
    create_3x3_grid()
    |> Common.set_open({0, 0}, :e)
    |> Common.set_open({0, 1}, :e)
    |> Common.set_open({2, 0}, :e)
    |> Common.set_open({2, 1}, :e)
    |> Display.format()
#    |> IO.puts()
  end

  # Not actually a test- just for visually checking
  test "process_grid() :e middle row" do
#    IO.puts("\nprocess_grid() :e middle")

#    %{
#      {1, 0} => MapSet.new([:e]),
#      {1, 1} => MapSet.new([:e])
#    }
    create_3x3_grid()
    |> Common.set_open({1, 0}, :e)
    |> Common.set_open({1, 1}, :e)
    |> Display.format()
#    |> IO.puts()
  end

  ###

  # Not actually a test- just for visually checking
  test "process_grid() :s left and right rows" do
#    IO.puts("\nprocess_grid() :s left and right")

#    %{
#      {0, 0} => MapSet.new([:s]),
#      {1, 0} => MapSet.new([:s]),
#      {0, 2} => MapSet.new([:s]),
#      {1, 2} => MapSet.new([:s])
#    }
    create_3x3_grid()
    |> Common.set_open({0, 0}, :s)
    |> Common.set_open({1, 0}, :s)
    |> Common.set_open({0, 2}, :s)
    |> Common.set_open({1, 2}, :s)
    |> Display.format()
#    |> IO.puts()
  end

  # Not actually a test- just for visually checking
  test "process_grid() :s middle row" do
#    IO.puts("\nprocess_grid() :s middle")

#    %{
#      {0, 1} => MapSet.new([:s]),
#      {1, 1} => MapSet.new([:s])
#    }
    create_3x3_grid()
    |> Common.set_open({0, 1}, :s)
    |> Common.set_open({1, 1}, :s)
    |> Display.format()
#    |> IO.puts()
  end

  ###

  # Not actually a test- just for visually checking
  test "process_grid() :e and :s all rows" do
#    IO.puts("\nprocess_grid() :e and :s all")

#    %{
#      {0, 0} => MapSet.new([:e, :s]),
#      {0, 1} => MapSet.new([:e, :s]),
#      {0, 2} => MapSet.new([:s]),
#      {1, 0} => MapSet.new([:e, :s]),
#      {1, 1} => MapSet.new([:e, :s]),
#      {1, 2} => MapSet.new([:s]),
#      {2, 0} => MapSet.new([:e]),
#      {2, 1} => MapSet.new([:e])
#    }
    create_3x3_grid()
    |> Common.set_open({0,0}, :e) |> Common.set_open({0,0}, :s)
    |> Common.set_open({0,1}, :e) |> Common.set_open({0,1}, :s)
    |> Common.set_open({0,2}, :s)
    |> Common.set_open({1,0}, :e) |> Common.set_open({1,0}, :s)
    |> Common.set_open({1,1}, :e) |> Common.set_open({1,1}, :s)
    |> Common.set_open({1,2}, :s)
    |> Common.set_open({2,0}, :e)
    |> Common.set_open({2,1}, :e)
    |> Display.format()
#    |> IO.puts()
  end

  ###

  defp create_3x3_grid() do
    Common.create_grid(3, 3)
  end

end

