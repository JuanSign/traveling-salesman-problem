class TSPSolver
  def self.solve(dist)
    n = dist.size
    full_mask = (1 << n) - 1

    dp = {}
    dp[[1 << 0, 0]] = [0.0, nil]

    (1..full_mask).each do |mask|
      (0...n).each do |u|
        next unless (mask & (1 << u)) != 0
        next unless dp.key?([mask, u])

        current_cost, _ = dp[[mask, u]]

        (0...n).each do |v|
          next if (mask & (1 << v)) != 0

          next_mask = mask | (1 << v)
          new_cost = current_cost + dist[u][v]

          if !dp.key?([next_mask, v]) || dp[[next_mask, v]][0] > new_cost
            dp[[next_mask, v]] = [new_cost, u]
            puts "Updating dp[mask=#{next_mask.to_s(2)}, v=#{v}] = (#{new_cost.round(2)}, from #{u})"
          end
        end
      end
    end

    min_cost = Float::INFINITY
    last_node = nil

    (1...n).each do |i|
      if dp.key?([full_mask, i])
        cost = dp[[full_mask, i]][0] + dist[i][0]
        if cost < min_cost
          min_cost = cost
          last_node = i
        end
      end
    end

    puts "Minimum tour cost: #{min_cost.round(2)}"
    puts "Last node before returning to 0: #{last_node}"

    path = [0]
    mask = full_mask
    current = last_node

    while current
      path << current
      _, prev = dp[[mask, current]]
      mask = mask & ~(1 << current)
      current = prev
    end

    path.reverse!
    path << 0 

    puts "Tour path: #{path.join(' -> ')}"

    [path, min_cost]
  end
end

if __FILE__ == $0
  dist = [
    [0.0, 29.0, 20.0, 21.0],
    [29.0, 0.0, 15.0, 17.0],
    [20.0, 15.0, 0.0, 28.0],
    [21.0, 17.0, 28.0, 0.0]
  ]

  path, cost = TSPSolver.solve(dist)
  puts "Optimal tour cost: #{cost.round(2)}"
  puts "Optimal tour: #{path.join(' -> ')}"
end
