# TSP Held-Karp Solver Implementations

This repository contains several implementations of the **Travelling Salesman Problem (TSP)** solver using the Held-Karp dynamic programming algorithm, written in different programming languages:

- C++
- Ruby
- Rust
- Elixir
- Swift
- Scala

---

## Contents

- `src/solver_c++/` — C++ implementation
- `src/solver_ruby/` — Ruby implementation
- `src/solver_rust/` — Rust implementation
- `src/solver_elixir/` — Elixir implementation
- `src/solver_swift/` — Swift implementation
- `src/solver_scala/` — Scala implementation

---

## How to Run Each Implementation

### 1. C++ Implementation

**Files:**  
- `parser.hpp` 
- `parser.cpp` 
- `solver.hpp`  
- `solver.cpp` 
- `main.cpp`

**Compile and Run:**

```bash
g++ -std=c++17 main.cpp solver.cpp parser.cpp -o solver
./solver <path_to_tsp_file>
```

### 2. Ruby Implementation

**File:** `solver.rb`

### Run
```bash
ruby solver.rb
```

### 3. Rust Implementation

**Files:**  
- `solver.rs` 
- `main.rs` 

### Run
```bash
cargo run
```

### 4. Elixir Implementation

**Files:**  
- `solver_elixir.ex` 
- `main.ex` 

### Run
```bash
elixir lib/main.ex
```

### 5. Swift Implementation

**File:** `solver.swift`

### Run
```bash
swift TSPSolver.swift
```

### 6. Scala Implementation

**File:** `solver.scala`

### Run
```bash
scalac solver.scala
scala solver
```






