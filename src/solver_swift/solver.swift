import Foundation

class TSPSolver {
    static func solve(dist: [[Double]]) -> ([Int], Double) {
        let n = dist.count
        let fullMask = (1 << n) - 1
        
        var dp = [ (Int, Int): (Double, Int) ]()
        dp[(1 << 0, 0)] = (0.0, -1)
        
        for mask in 1...fullMask {
            for u in 0..<n {
                guard (mask & (1 << u)) != 0 else { continue }
                guard let (cost, _) = dp[(mask, u)] else { continue }
                
                for v in 0..<n {
                    if (mask & (1 << v)) == 0 {
                        let nextMask = mask | (1 << v)
                        let newCost = cost + dist[u][v]
                        let existingCost = dp[(nextMask, v)]?.0 ?? Double.greatestFiniteMagnitude
                        if newCost < existingCost {
                            dp[(nextMask, v)] = (newCost, u)
                            print(String(format: "Updating dp[mask=0x%X, v=%d] = (%.2f, from %d)", nextMask, v, newCost, u))
                        }
                    }
                }
            }
        }
        
        var minCost = Double.greatestFiniteMagnitude
        var lastCity = -1
        for i in 1..<n {
            if let (cost, _) = dp[(fullMask, i)] {
                let totalCost = cost + dist[i][0]
                if totalCost < minCost {
                    minCost = totalCost
                    lastCity = i
                }
            }
        }
        
        var path = [0]
        var mask = fullMask
        var current = lastCity
        
        while current != -1 {
            path.append(current)
            let prev = dp[(mask, current)]!.1
            mask &= ~(1 << current)
            current = prev
        }
        
        path.reverse()
        path.append(0) 
        
        print("Tour path: \(path.map(String.init).joined(separator: " -> "))")
        
        return (path, minCost)
    }
}

let dist = [
    [0.0, 29.0, 20.0, 21.0],
    [29.0, 0.0, 15.0, 17.0],
    [20.0, 15.0, 0.0, 28.0],
    [21.0, 17.0, 28.0, 0.0]
]

let (tour, cost) = TSPSolver.solve(dist: dist)
print(String(format: "Optimal tour cost: %.2f", cost))
print("Optimal tour: \(tour.map(String.init).joined(separator: " -> "))")
