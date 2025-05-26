defmodule TSPSolver do
  @moduledoc """
  Held-Karp algorithm implementation for solving TSP in Elixir.
  """

  use Bitwise

  def solve(dist) do
    n = length(dist)
    full_mask = bsl(1, n)

    dp = %{ {1 <<< 0, 0} => {0.0, nil} }

    dp = Enum.reduce(1..(full_mask - 1), dp, fn mask, acc_dp ->
      Enum.reduce(0..(n - 1), acc_dp, fn u, acc_dp2 ->
        if (mask &&& (1 <<< u)) == 0 do
          acc_dp2
        else
          Enum.reduce(0..(n - 1), acc_dp2, fn v, acc_dp3 ->
            if (mask &&& (1 <<< v)) != 0 or u == v do
              acc_dp3
            else
              next_mask = mask ||| (1 <<< v)
              current_cost = acc_dp2[{mask, u}] |> elem(0)
              new_cost = current_cost + get_dist(dist, u, v)

              case Map.get(acc_dp3, {next_mask, v}) do
                nil ->
                  Map.put(acc_dp3, {next_mask, v}, {new_cost, u})

                {old_cost, _} when new_cost < old_cost ->
                  Map.put(acc_dp3, {next_mask, v}, {new_cost, u})

                _ ->
                  acc_dp3
              end
            end
          end)
        end
      end)
    end)

    final_mask = full_mask - 1

    {min_cost, last_city} =
      1..(n - 1)
      |> Enum.map(fn i ->
        {cost, _} = dp[{final_mask, i}]
        {cost + get_dist(dist, i, 0), i}
      end)
      |> Enum.min_by(fn {c, _} -> c end)

    path = reconstruct_path(dp, final_mask, last_city, [0], n)

    IO.puts("Minimum cost: #{min_cost}")
    IO.puts("Tour: #{Enum.reverse(path)}")

    {Enum.reverse(path), min_cost}
  end

  defp reconstruct_path(_dp, 1, 0, acc, _n), do: [0 | acc]

  defp reconstruct_path(dp, mask, curr, acc, n) do
    {_, prev} = dp[{mask, curr}]
    reconstruct_path(dp, mask ^^^ (1 <<< curr), prev, [curr | acc], n)
  end

  defp get_dist(dist, i, j), do: dist |> Enum.at(i) |> Enum.at(j)
end
