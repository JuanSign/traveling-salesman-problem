mod solver;

fn main() {
    let dist = vec![
        vec![0.0, 2.0, 9.0, 10.0],
        vec![1.0, 0.0, 6.0, 4.0],
        vec![15.0, 7.0, 0.0, 8.0],
        vec![6.0, 3.0, 12.0, 0.0],
    ];

    let (path, cost) = solver::solve_tsp(&dist);
    println!("Optimal path: {:?}", path);
    println!("Minimum cost: {:.2}", cost);
}
