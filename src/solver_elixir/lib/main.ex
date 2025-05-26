defmodule Main do
  def run do
    dist = [
      [0.0, 2.0, 9.0, 10.0],
      [1.0, 0.0, 6.0, 4.0],
      [15.0, 7.0, 0.0, 8.0],
      [6.0, 3.0, 12.0, 0.0]
    ]

    TSPSolver.solve(dist)
  end
end

Main.run()
