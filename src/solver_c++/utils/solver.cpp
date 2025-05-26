#include "solver.hpp"

#include <vector>
#include <limits>
#include <cmath>
#include <unordered_map>

std::pair<std::vector<int>, double> SOLVER::Solve(const std::vector<std::vector<double>> &dist)
{
    int n = dist.size();
    int FULL_MASK = (1 << n);
    std::vector<std::vector<double>> dp(FULL_MASK, std::vector<double>(n, std::numeric_limits<double>::infinity()));
    std::vector<std::vector<int>> parent(FULL_MASK, std::vector<int>(n, -1));

    dp[1][0] = 0.0;

    for (int mask = 1; mask < FULL_MASK; ++mask)
    {
        for (int u = 0; u < n; ++u)
        {
            if (!(mask & (1 << u)))
                continue;
            for (int v = 0; v < n; ++v)
            {
                if (mask & (1 << v))
                    continue;
                int next_mask = mask | (1 << v);
                double new_cost = dp[mask][u] + dist[u][v];
                if (new_cost < dp[next_mask][v])
                {
                    dp[next_mask][v] = new_cost;
                    parent[next_mask][v] = u;
                }
            }
        }
    }

    double min_cost = std::numeric_limits<double>::infinity();
    int last_city = -1;
    for (int i = 1; i < n; ++i)
    {
        double cost = dp[FULL_MASK - 1][i] + dist[i][0];
        if (cost < min_cost)
        {
            min_cost = cost;
            last_city = i;
        }
    }

    std::vector<int> path(n + 1);
    int mask = FULL_MASK - 1;
    int curr = last_city;

    for (int i = n - 1; i >= 1; --i)
    {
        path[i] = curr;
        int temp = parent[mask][curr];
        mask ^= (1 << curr);
        curr = temp;
    }
    path[0] = 0;
    path[n] = 0;

    return {path, min_cost};
}
