use std::f64;

pub fn solve_tsp(dist: &Vec<Vec<f64>>) -> (Vec<usize>, f64) {
    let n = dist.len();
    let full_mask = 1 << n;
    let mut dp = vec![vec![f64::INFINITY; n]; full_mask];
    let mut parent = vec![vec![None; n]; full_mask];

    println!("Starting Held-Karp TSP solver for {} cities.", n);

    dp[1][0] = 0.0;

    for mask in 1..full_mask {
        for u in 0..n {
            if mask & (1 << u) == 0 {
                continue;
            }

            for v in 0..n {
                if mask & (1 << v) != 0 {
                    continue;
                }

                let next_mask = mask | (1 << v);
                let new_cost = dp[mask][u] + dist[u][v];

                if new_cost < dp[next_mask][v] {
                    dp[next_mask][v] = new_cost;
                    parent[next_mask][v] = Some(u);

                    println!(
                        "dp[mask={:0width$b}][v={}] = {:.2} (via u={})",
                        next_mask,
                        v,
                        new_cost,
                        u,
                        width = n
                    );
                }
            }
        }
    }

    let mut min_cost = f64::INFINITY;
    let mut last_city = 0;
    for i in 1..n {
        let cost = dp[full_mask - 1][i] + dist[i][0];
        println!("Final leg: city {} to 0, cost = {:.2}", i, cost);
        if cost < min_cost {
            min_cost = cost;
            last_city = i;
        }
    }

    let mut path = vec![0; n + 1];
    path[n] = 0;
    let mut mask = full_mask - 1;
    let mut curr = last_city;

    for i in (1..n).rev() {
        path[i] = curr;
        let prev = parent[mask][curr].unwrap();
        println!("Backtracking: path[{}] = {}, from {}", i, curr, prev);
        mask ^= 1 << curr;
        curr = prev;
    }
    path[0] = 0;

    println!("Completed TSP with cost = {:.2}", min_cost);
    println!("Tour: {:?}", path);

    (path, min_cost)
}
