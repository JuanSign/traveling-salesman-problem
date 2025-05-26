import scala.math._
import scala.collection.mutable

object TSPSolver {

  def solve(dist: Array[Array[Double]]): (List[Int], Double) = {
    val n = dist.length
    val dp = mutable.Map[(Int, Int), (Double, Int)]()
    val fullMask = (1 << n) - 1

    dp((1 << 0, 0)) = (0.0, -1)

    for (mask <- 1 until (1 << n)) {
      for (u <- 0 until n if (mask & (1 << u)) != 0) {
        dp.get((mask, u)).foreach { case (cost, _) =>
          for (v <- 0 until n if (mask & (1 << v)) == 0) {
            val nextMask = mask | (1 << v)
            val newCost = cost + dist(u)(v)
            val existing = dp.get((nextMask, v)).map(_._1).getOrElse(Double.MaxValue)

            if (newCost < existing) {
              dp((nextMask, v)) = (newCost, u)
              println(f"Updating dp[mask=$nextMask%X, v=$v] = ($newCost%.2f, from $u)")
            }
          }
        }
      }
    }

    val (minCost, lastCity) = (1 until n).map { i =>
      val (cost, _) = dp((fullMask, i))
      (cost + dist(i)(0), i)
    }.minBy(_._1)

    println(f"Minimum tour cost: $minCost%.2f")
    println(s"Last city before returning to 0: $lastCity")

    def reconstructPath(mask: Int, curr: Int, acc: List[Int]): List[Int] = {
      if (curr == -1) acc
      else {
        val (_, prev) = dp((mask, curr))
        reconstructPath(mask ^ (1 << curr), prev, curr :: acc)
      }
    }

    val path = reconstructPath(fullMask, lastCity, List(0))
    println(s"Tour path: ${path.mkString(" -> ")}")
    (path, minCost)
  }

  def main(args: Array[String]): Unit = {
    val dist = Array(
      Array(0.0, 29.0, 20.0, 21.0),
      Array(29.0, 0.0, 15.0, 17.0),
      Array(20.0, 15.0, 0.0, 28.0),
      Array(21.0, 17.0, 28.0, 0.0)
    )

    val (tour, cost) = solve(dist)
    println(f"Optimal tour cost: $cost%.2f")
    println(s"Optimal tour: ${tour.mkString(" -> ")}")
  }
}
