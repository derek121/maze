# Maze

Create a maze using a recursive backtracking algorithm. Inspired by http://weblog.jamisbuck.org/2010/12/27/maze-generation-recursive-backtracking

Overview of the algorithm, from that page:  

* Choose a starting point in the field.  
* Randomly choose a wall at that point and carve a passage through to the adjacent cell, but only if the adjacent cell has not been visited yet. This becomes the new current cell.  
* If all adjacent cells have been visited, back up to the last cell that has uncarved walls and repeat.  
* The algorithm ends when the process has backed all the way up to the starting point.

## Example

```elixir
Maze.Common.create_grid(20, 20)
|> Maze.RecursiveBacktracking.MazeRB.carve_passages_from({0,0})
|> Maze.Display.format()
|> IO.puts()
```

```
┌───┬┬──┬─────┬─────┐
┝──┐││╷┌┘┌─┐╶┐╵┌╴┌┬╴│
│╷╶┘│╵││╶┥╷└┐└─┥┌┘╵┌┥
│┝──┘╶┥└╴│└┐└┐┌┘│╶┬┘│
│┝─┬─┐└──┿╴┝┐└┥┌┴┐│╷│
│╵╷│╷└───┘┌┥└╴│╵╷│╵││
┝─┥╵┝───┬─┘│┌─┴┐│┝─┘│
│╶┴┬┘╷┌╴└┬╴││┌╴┝┘┝─┐│
│╷╶┥┌┘┝─┐╵┌┘│└┐╵┌┘╷││
│┝╴││┌┘╷└┐│╶┥╷└─┥╶┥││
┝┘┌┘│╵┌┴┐└┿╴│┝─┐└╴│└┥
│┌┘┌┴─┥╶┴┐╵┌┴┘╷┝──┴┐│
││╶┿─┐╵╷╶┴─┴╴┌┥│╶─┐││
│└┐╵╷┝─┴┐╷┌──┥│└┬╴│││
┝╴└┬┘│╶┐└┘│╷╷╵└┐╵┌┘││
│┌╴│╶┴┐┝──┴┥│┌─┴─┘┌┘│
││╶┴─┐││╶┬╴│││╶┬──┘╷│
│└───┥│└╴│┌┥└┴╴┝─┐┌┥│
│┌──┐││┌─┥│╵┌──┘╷╵│││
│└─╴│╵└┘╷╵│╶┴─╴┌┴─┘╵│
└───┴───┴─┴────┴────┘
```

